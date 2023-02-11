function Hologram = expanded_transfer_GPU_n_exview(Background_amp, expansion_factor, theta_recon, phi_recon, theta_obs, phi_obs, z_propagation, symmetry_mode,n_material,ex_view) 
%% 2019-08-21 ������
% z_propagation�� ���� �� �ֱ⿡�� �Ѿ���� ���е��� ��õ������ �����ϴ� �ڵ� �߰�
% ���� expansion_factor�� 2 �ʰ��� �ʿ� ���� (2�� �ϸ� ���)
%% 2019-10-12 ������
% ����ȭ�� ��꺯���� ���� ������ clear�� �ҿ�Ǵ� �ð��� �޸� Ȱ�� ����ȭ 
% fftshift �Լ��� ���� �ʰ� ������ -> Nx�� Ȧ�� �����϶� ���� �ڵ尡 ������ �ִµ� �ʹ� �������� �� ��Ȯ�ѰŰ���..?
% ¦���϶� ���� ���� �Ȱ��� �׳�
%% 2019-11-25 ������
% �ȼ� ũ�Ⱑ �ʹ� �۾����� ex_ww ���� ����� �Ǿ �߻��Ѵ� (NaN ����)
% �̸� �ذ��ϱ� ���� ex_ww �տ� real ���ߴ�.
%% 2020-01-07 ������
% ex_ww �� .*((fft_uu).^2 + (fft_vv).^2 <= max(u).^2)) �߰��ؼ� �����Լ� ��� ���׶���
%% 2020-08-22 ������
% 1) �е��Ҷ� ��ü�� ���ϰ� �߶� �����ν� �޸� ����
% 2) �Է��� ������ ��� (matfile �Լ� ���� ���) ����
%%
 t3=clock; % ��� ��Ʈ �ð� ���
global lambda px py Nx Ny Ideal_angle_limit CPU_max_Nx GPU_max_Nx;

% ex_view = ceil(ex_view);

if ex_view > expansion_factor
    expansion_factor =ex_view;
end

if symmetry_mode == 1
        NN = max(Nx,Ny);   Nx = NN; Ny = NN;
end

if Ideal_angle_limit >= atand(expansion_factor/2*Nx*px/abs(z_propagation))
    disp(['�˸�:  Ideal_angle_limit >= atand(Nx*px/z_propagation) �̱⿡ ���ļ� ���͸� ���۽�ŵ�ϴ�!']);
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
%% �ȼ����� ���� ��
if expansion_factor*NN <= decision_factor*4 % 16k ���� ���� ������ �������� ����
%%
if theta_recon ~= 0  
   kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
   ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);
 
   xx_small = single(px*[-Nx/2+1:Nx/2]);
   yy_small = single(py*[-Ny/2+1:Ny/2]);   
   ex_map = Background_amp.*exp(-1j*(kx_recon*repmat(xx_small,size(yy_small.'))+ky_recon*repmat(yy_small.',size(xx_small))  ));  % ���Ի��Ѵ�
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
 
 ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-(fft_uu).^2 - (fft_vv).^2)));% 2019-11-25 ������ real �߰� NAN �߻����� �ذ�
 ex_map = ex_map.*exp(- j * 2 * pi * ex_ww * z_propagation).* exp( j * 2 * pi * (x0 * fft_uu + y0 * fft_vv));
 clear ex_ww;

 ex_map = ifft2(ex_map);
 
 y_range = ex_Ny/2-ex_view*Ny/2+1:ex_Ny/2+ex_view*Ny/2;   x_range = ex_Nx/2-ex_view*Nx/2+1:ex_Nx/2+ex_view*Nx/2;
 Hologram = gather(ex_map(y_range, x_range));
 
disp(['  "Expanded transfer" calculation time : ' num2str(etime(clock,t3))]);

%% �ȼ��� ������ ���� ����
elseif expansion_factor*NN <= decision_factor*10000 %long-distance strip-based diffraction // ���Ի� ���� ������ �̱���
t3=clock; 
if theta_recon ~= 0  
   kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
   ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);
   
   xx_small = single(px*[-Nx/2+1:Nx/2]);
   yy_small = single(py*[-Ny/2+1:Ny/2]);  
end

if Nx < CPU_max_Nx   % ������ ������ ����, 1000* <- ���� ������
ex_map = zeros([ex_Ny Nx],'single'); CPU_over = 0;
else   % ������ ���� ����
      filename = 'ex_map'; CPU_over = 1;%�뷮�� Ŀ�� SSD������ Ȱ���Ѵ�.
fileID_r = fopen([filename '_real.bin'],'w+'); 
fileID_i = fopen([filename '_imag.bin'],'w+');
end


u = fftshift(single(ex_dfx*[-ex_Nx/2+1:ex_Nx/2]));
v = fftshift(single(ex_dfy*[-ex_Ny/2+1:ex_Ny/2]));

division_num = 2^ceil(log2(expansion_factor^2*NN^2/(decision_factor*1.2)^2)); % GPU �޸� ������ log2 �ȿ��ٰ� *2 *4 �غ�����.
division_num = find_good_div_num(division_num,Nx);


disp(['       division_num : ' num2str(division_num)]);

 
for cnt1 = 1:1:division_num/2
disp(['       Iteration part 1 : ' num2str(cnt1) '/' num2str(division_num/2)]);
Nx_div = Nx/(division_num/2); Nx_div_range = Nx_div*(cnt1-1)+1:Nx_div*cnt1;

if theta_recon ~= 0 
temp = padarray(gpuArray(Background_amp(:,Nx_div_range).*exp(-1j*(kx_recon*repmat(xx_small(Nx_div_range),size(yy_small.'))+ky_recon*repmat(yy_small.',size(xx_small(Nx_div_range)))))) , [(expansion_factor-1)*Ny/2 0]);  % ���Ի��Ѵ�
else
temp = padarray(gpuArray(Background_amp(:,Nx_div_range)),[(expansion_factor-1)*Ny/2 0]);
end

if CPU_over == 0 
ex_map(1:ex_Ny,Nx_div*(cnt1-1)+1:Nx_div*cnt1) = gather(fft(temp));
else
% m.ex_map(1:ex_Ny,Nx_div*(cnt1-1)+1:Nx_div*cnt1) = gather(fft(temp)); %<-- �׳� ������� �ɵ�?
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
ex_FFT_amp =  fft(padarray(gpuArray(temp).',[(expansion_factor-1)*NN/2 0])); % �а� ��ŵ�ϰ� �ؾ���
end    
    
%% ���� ex_uu, ex_vv�� transpose�� �� �������� �߶� �ͱ��� ��� ������ ������
 ex_uu_final = repmat(u.',[1 Ny_div]);
 ex_vv_final = repmat(v(Ny_div*(cnt2-1)+1:Ny_div*cnt2), [ex_Nx 1]);
%%

if ASM_filter == 1
uv_filter = (abs(ex_uu_final+u_obs) < sind(theta_limit)/lambda) & ( abs(ex_vv_final+v_obs) < sind(theta_limit)/lambda); % 2019-11-25����
ex_FFT_amp = ex_FFT_amp.*uv_filter;
clear uv_filter;
end 


%%
ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-ex_uu_final.^2 - ex_vv_final.^2)).*((ex_uu_final).^2 + (ex_vv_final).^2 <= max(u).^2)); % 2020-01-07 ����

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

%% ������ �ڵ� ��� 2019-10-12
%  t2=clock; % ��� ��Ʈ �ð� ���
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
    




