function Hologram = expanded_transfer_GPU_n_exview(Background_amp, expansion_factor, theta_recon, phi_recon, theta_obs, phi_obs, z_propagation, symmetry_mode,n_material,ex_view) 
%% 2019-08-21 수정점
% z_propagation에 따라 옆 주기에서 넘어오는 성분들을 원천적으로 차폐하는 코드 추가
% 이제 expansion_factor가 2 초과할 필요 없음 (2만 하면 충분)
%% 2019-10-12 수정점
% 안정화된 계산변수는 덮어 씌워서 clear에 소요되는 시간과 메모리 활용 최적화 
% fftshift 함수를 쓰지 않고 구현함 -> Nx가 홀수 개수일때 기존 코드가 문제가 있는듯 싶다 수정본이 더 정확한거같음..?
% 짝수일땐 둘이 거의 똑같다 그냥
%% 2019-11-25 수정점
% 픽셀 크기가 너무 작아지면 ex_ww 값이 허수가 되어서 발산한다 (NaN 나옴)
% 이를 해결하기 위해 ex_ww 앞에 real 취했다.
%% 2020-01-07 수정점
% ex_ww 에 .*((fft_uu).^2 + (fft_vv).^2 <= max(u).^2)) 추가해서 전달함수 모양 동그랗게
%% 2020-08-22 수정점
% 1) 패딩할때 전체를 안하고 잘라서 함으로써 메모리 절약
% 2) 입력이 더미인 경우 (matfile 함수 쓰는 경우) 적용
%%
 t3=clock; % 재생 파트 시간 계산
global lambda px py Nx Ny Ideal_angle_limit CPU_max_Nx GPU_max_Nx;

% ex_view = ceil(ex_view);

if ex_view > expansion_factor
    expansion_factor =ex_view;
end

if symmetry_mode == 1
        NN = max(Nx,Ny);   Nx = NN; Ny = NN;
end

if Ideal_angle_limit >= atand(expansion_factor/2*Nx*px/abs(z_propagation))
    disp(['알림:  Ideal_angle_limit >= atand(Nx*px/z_propagation) 이기에 주파수 필터를 동작시킵니다!']);
    ASM_filter = 1;
    theta_limit = atand(expansion_factor/2*Nx*px/abs(z_propagation));
    disp(['       theta_limit : ' num2str(theta_limit)]);
    u_obs = sind(theta_obs)*cosd(phi_obs)/lambda;  v_obs = sind(theta_obs)*sind(phi_obs)/lambda;
else
    ASM_filter = 0;
end

decision_factor = GPU_max_Nx*0.8;
% decision_factor = 900;

ex_Nx = Nx*expansion_factor; ex_Ny = Ny*expansion_factor; % num of pixel
ex_size_x = ex_Nx*px;  ex_size_y = ex_Nx*py; % hologram size
ex_dfx = 1/ex_size_x; ex_dfy = 1/ex_size_y;

x0 = tand(theta_obs)*cosd(phi_obs)*z_propagation;
y0 = tand(theta_obs)*sind(phi_obs)*z_propagation;
%% 픽셀수가 작을 때
if expansion_factor*NN <= decision_factor*4 % 16k 보다 맵이 작으면 분할하지 않음
%%
if theta_recon ~= 0  
   kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
   ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);
 
   xx_small = single(px*[-Nx/2+1:Nx/2]);
   yy_small = single(py*[-Ny/2+1:Ny/2]);   
   ex_map = Background_amp.*exp(-1j*(kx_recon*repmat(xx_small,size(yy_small.'))+ky_recon*repmat(yy_small.',size(xx_small))  ));  % 사입사한다
   ex_map = padarray(gpuArray(ex_map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]);
else
   ex_map = padarray(gpuArray(Background_amp), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]);
end 

u = single(ex_dfx*[-ex_Nx/2+1:ex_Nx/2]);
v = single(ex_dfy*[-ex_Ny/2+1:ex_Ny/2]);

fftu = fftshift(u); fftv = fftshift(v);
fft_uu = repmat(fftu,size(fftv.'));  fft_vv=repmat(fftv',size(fftu));

  ex_map = fft2(ex_map);
  
 if ASM_filter == 1
 uv_filter = (abs(fft_uu+u_obs) < sind(theta_limit)/lambda) & ( abs(fft_vv+v_obs) < sind(theta_limit)/lambda);
 ex_map = ex_map.*uv_filter;
 clear uv_filter;
 end 
 
 ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-(fft_uu).^2 - (fft_vv).^2)));% 2019-11-25 수정됨 real 추가 NAN 발생문제 해결
 ex_map = ex_map.*exp(- j * 2 * pi * ex_ww * z_propagation).* exp( j * 2 * pi * (x0 * fft_uu + y0 * fft_vv));
 clear ex_ww;

 ex_map = ifft2(ex_map);
 
 y_range = ex_Ny/2-ex_view*Ny/2+1:ex_Ny/2+ex_view*Ny/2;   x_range = ex_Nx/2-ex_view*Nx/2+1:ex_Nx/2+ex_view*Nx/2;
 Hologram = gather(ex_map(y_range, x_range));
 
disp(['  "Expanded transfer" calculation time : ' num2str(etime(clock,t3))]);

%% 픽셀수 많으면 여기 수정
elseif expansion_factor*NN <= decision_factor*10000 %long-distance strip-based diffraction // 사입사 구현 관측면 미구현
t3=clock; 
if theta_recon ~= 0  
   kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
   ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);
   
   xx_small = single(px*[-Nx/2+1:Nx/2]);
   yy_small = single(py*[-Ny/2+1:Ny/2]);  
end

if Nx < CPU_max_Nx   % 씨피유 안터짐 조건, 1000* <- 강제 안터짐
ex_map = zeros([ex_Ny Nx],'single'); CPU_over = 0;
else   % 씨피유 터짐 조건
      filename = 'ex_map'; CPU_over = 1;%용량이 커서 SSD저장을 활용한다.
fileID_r = fopen([filename '_real.bin'],'w+'); 
fileID_i = fopen([filename '_imag.bin'],'w+');
end


u = fftshift(single(ex_dfx*[-ex_Nx/2+1:ex_Nx/2]));
v = fftshift(single(ex_dfy*[-ex_Ny/2+1:ex_Ny/2]));

division_num = 2^ceil(log2(expansion_factor^2*NN^2/(decision_factor*1.2)^2)); % GPU 메모리 터지면 log2 안에다가 *2 *4 해보세요.
division_num = find_good_div_num(division_num,Nx);


disp(['       division_num : ' num2str(division_num)]);

 
for cnt1 = 1:1:division_num/2
disp(['       Iteration part 1 : ' num2str(cnt1) '/' num2str(division_num/2)]);
Nx_div = Nx/(division_num/2); Nx_div_range = Nx_div*(cnt1-1)+1:Nx_div*cnt1;

if theta_recon ~= 0 
temp = padarray(gpuArray(Background_amp(:,Nx_div_range).*exp(-1j*(kx_recon*repmat(xx_small(Nx_div_range),size(yy_small.'))+ky_recon*repmat(yy_small.',size(xx_small(Nx_div_range)))))) , [(expansion_factor-1)*Ny/2 0]);  % 사입사한다
else
temp = padarray(gpuArray(Background_amp(:,Nx_div_range)),[(expansion_factor-1)*Ny/2 0]);
end

if CPU_over == 0 
ex_map(1:ex_Ny,Nx_div*(cnt1-1)+1:Nx_div*cnt1) = gather(fft(temp));
else
% m.ex_map(1:ex_Ny,Nx_div*(cnt1-1)+1:Nx_div*cnt1) = gather(fft(temp)); %<-- 그냥 써넣으면 될듯?
fwrite(fileID_r,gather(real(fft(temp))),'single'); 
fwrite(fileID_i,gather(imag(fft(temp))),'single');
end

end
 
if CPU_over == 1 
      fclose(fileID_r); fclose(fileID_i);
end
      
disp(['  "Loop 1" calculation time : ' num2str(etime(clock,t3))]);

t3=clock; 



for cnt2 = 1:1:division_num*expansion_factor
disp(['       Iteration part 2 : ' num2str(cnt2) '/' num2str(division_num*expansion_factor)]);
Ny_div =   Ny/division_num;  
y_range = Ny_div*(cnt2-1)+1:Ny_div*cnt2;

if CPU_over == 0
ex_FFT_amp =  fft(padarray(gpuArray(ex_map(y_range,:)).',[(expansion_factor-1)*NN/2 0]));
else
temp = bin_read(filename,[ex_Ny Nx],[Ny_div Nx],[y_range(1) 1]);       
ex_FFT_amp =  fft(padarray(gpuArray(temp).',[(expansion_factor-1)*NN/2 0])); % 읽고 스킵하고 해야해
end    
    
%% 기존 ex_uu, ex_vv를 transpose한 뒤 구간별로 잘라낸 것까지 모두 포함한 연산임
 ex_uu_final = repmat(u.',[1 Ny_div]);
 ex_vv_final = repmat(v(Ny_div*(cnt2-1)+1:Ny_div*cnt2), [ex_Nx 1]);
%%

if ASM_filter == 1
uv_filter = (abs(ex_uu_final+u_obs) < sind(theta_limit)/lambda) & ( abs(ex_vv_final+v_obs) < sind(theta_limit)/lambda); % 2019-11-25수정
ex_FFT_amp = ex_FFT_amp.*uv_filter;
clear uv_filter;
end 


%%
ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-ex_uu_final.^2 - ex_vv_final.^2)).*((ex_uu_final).^2 + (ex_vv_final).^2 <= max(u).^2)); % 2020-01-07 수정

if theta_obs == 0
ex_FFT_amp = ex_FFT_amp.*exp( - 1j * 2 * pi * ex_ww * z_propagation);
else
ex_FFT_amp = ex_FFT_amp.*exp( - 1j * 2 * pi * ex_ww * z_propagation).* exp( j * 2 * pi * (x0 *ex_uu_final + y0 * ex_vv_final));    
end

clear ex_ww; 
ex_FFT_amp = gather(ifft(ex_FFT_amp));

if CPU_over == 0
ex_map(Ny_div*(cnt2-1)+1:Ny_div*cnt2,1:Nx) = ex_FFT_amp(ex_Nx/2-Nx/2+1:ex_Nx/2+Nx/2,:).';
else
bin_write(ex_FFT_amp(ex_Nx/2-Nx/2+1:ex_Nx/2+Nx/2,:).',filename,[ex_Ny Nx],[Ny_div*(cnt2-1)+1 1]);    
end

end
 disp(['  "Loop 2" calculation time : ' num2str(etime(clock,t3))]);


Hologram = zeros(Ny,Nx,'single');

t3=clock;
for cnt3 = 1:1:division_num/2
disp(['       Iteration part 3 : ' num2str(cnt3) '/' num2str(division_num/2)]);
Nx_div =   Nx/(division_num/2);
if CPU_over == 0 
temp =  gather(ifft(gpuArray(ex_map(:,Nx_div*(cnt3-1)+1:Nx_div*cnt3))));
else
temp =  bin_read(filename,[ex_Ny Nx],[ex_Ny length(Nx_div*(cnt3-1)+1:Nx_div*cnt3)],[1 Nx_div*(cnt3-1)+1])  ;  
temp =  gather(ifft(gpuArray( temp )));    
end
Hologram(:,Nx_div*(cnt3-1)+1:Nx_div*cnt3) = temp(ex_Ny/2-Ny/2+1:ex_Ny/2+Ny/2,:);
end

if CPU_over == 1
  delete([filename '_real.bin']); delete([filename '_imag.bin']);
end

 disp(['  "Loop 3" calculation time : ' num2str(etime(clock,t3))]);

%% 구버전 코드 백업 2019-10-12
%  t2=clock; % 재생 파트 시간 계산
%  
%  ex_map = padarray(gpuArray(Background_amp), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]);
%  
%  ex_map = ifftshift(fft2(fftshift(ex_map)));
%  
%  if ASM_filter == 1
%  uv_filter = (abs(ex_uu+u_obs) < sind(theta_limit)/lambda) & ( abs(ex_vv+v_obs) < sind(theta_limit)/lambda);
%  ex_map = ex_map.*uv_filter;
%  end 
%  
%  
%  ex_ww = gpuArray(sqrt(1/lambda^2-(ex_uu).^2 - (ex_vv).^2)); 
%  ex_map = ex_map.*exp(- j * 2 * pi * ex_ww * z_propagation).* exp( j * 2 * pi * (x0 * ex_uu + y0 * ex_vv));
%   
%  ex_map = fftshift(ifft2(ifftshift(ex_map)));
%  
%  y_range = ex_Ny/2-Ny/2+1:ex_Ny/2+Ny/2;   x_range = ex_Nx/2-Nx/2+1:ex_Nx/2+Nx/2;
%  Hologram1 = gather(ex_map(y_range, x_range));
%  
%  disp(['  "t2" calculation time : ' num2str(etime(clock,t2))]);

end
    




