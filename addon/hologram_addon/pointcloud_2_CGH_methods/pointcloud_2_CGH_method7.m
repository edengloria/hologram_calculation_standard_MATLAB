%% 2020/09/17 7번 방법: 4번 방법 개선한 최신 버전 코드
global CPU_max_Nx GPU_max_Nx system_angle_limit Ideal_angle_limit;

point_number = size(point_array,2); 
if z_num == 1
     zz = mean(point_array(3,:));
else
     zz =  linspace(min(point_array(3,:)),max(point_array(3,:)),z_num); 
end
                   
%% 가까운 점으로 매핑하고, 중복되는 점은 지운다
[x_p, y_p, z_p] = mapping_and_erasing_points(xx,yy,zz,point_array,point_number,z_num);
% system_angle_limit = double(max(atand(sqrt((abs(xx(x_p))+xx(end)).^2+(abs(yy(y_p))+yy(end)).^2)./abs(zz(z_p)))))-0.01;
disp(['       system_angle_limit (degree) : ' num2str(system_angle_limit)]); %주어진 홀로그램 상을 만들기 위해서 필요한 최대 각도 성분을 알려준다.


%% ex2배는 적용해야함.. 주파수 필터는 extransfer 와 동일하게
clear point_array;

expansion_factor = 2;
ex_Nx = Nx*expansion_factor; ex_Ny = Ny*expansion_factor; % num of pixel
ex_size_x = ex_Nx*px;
ex_size_y = ex_Nx*py; % hologram size
ex_dfx = 1/ex_size_x; ex_dfy = 1/ex_size_y; 
n_material = 1;

GPU_decision_factor = GPU_max_Nx;

if Ideal_angle_limit >= atand(Nx*px/min(abs(zz))) %상이 회절각 대비 멀다
    disp(['알림:  Ideal_angle_limit >= atand(Nx*px/z_propagation) 이기에 주파수 필터를 동작시킵니다!']);
    ASM_filter = 1;
    theta_limit_max = atand(Nx*px/min(abs(zz)));
%    theta_limit_max = system_angle_limit;
    disp(['       theta_limit : ' num2str(theta_limit_max)]);
    
    filter_size = floor(sind(theta_limit_max)/lambda/ex_dfx);
    GPU_division_num = max(1,2^ceil(log2(2*filter_size/GPU_decision_factor)));
    range = 2*filter_size/GPU_division_num;
    division_num = 2^floor(log2(range)/2);

    filter_size = ceil(filter_size/division_num/GPU_division_num)*division_num*GPU_division_num;
    range = 2*filter_size/GPU_division_num;
    pad_num = double( ex_Nx/2 - filter_size);

else %상이 회절각 대비 가깝다
    ASM_filter = 0;

    theta_limit_max = Ideal_angle_limit;
    disp(['       theta_limit : ' num2str(Ideal_angle_limit) ' is Ideal angle limit!' ]);
    
    filter_size = ex_Nx/2;
    GPU_division_num = max(1,2^ceil(log2(2*filter_size/GPU_decision_factor)));
    range = 2*filter_size/GPU_division_num;
    division_num = 2^floor(log2(range)/2);

    filter_size = floor(filter_size/division_num/GPU_division_num)*division_num*GPU_division_num;
    range = 2*filter_size/GPU_division_num;
    pad_num =double( ex_Nx/2 - filter_size);
end

%%
   if filter_size <= CPU_max_Nx
      ex_map = zeros(2*filter_size,2*filter_size,'single');
      CPU_over = 0;
   else 
      filename = 'temp_map'; filename2 = 'complex_temp';%용량이 커서 SSD저장을 활용한다.
      bin_delete(filename);bin_delete(filename2);
      bin_create_zero(2*filter_size*2*filter_size,filename);
      CPU_over = 1;     
   end
%%

disp([' CPU_over :  ' num2str(CPU_over)  ]); 
countuv = 1; cnt = 1;
rand_array = rand([length(z_p) 1],'single');

%% 병렬 처리 미적용 GPU <- 원래꺼
for vv_cnt = 1:GPU_division_num
    for uu_cnt = 1:GPU_division_num
        
    vv_range = -filter_size  + [(vv_cnt-1)*range+1: vv_cnt*range];
    uu_range = -filter_size  + [(uu_cnt-1)*range+1: uu_cnt*range];
    
    u = gpuArray(single(ex_dfx*[uu_range])); 
    v = gpuArray(single(ex_dfx*[vv_range]));
    
if min(min(sqrt(repmat(u,size(v.')).^2+repmat(v',size(u)).^2))) > sind(theta_limit_max)/lambda    
else    
     mini_map = gpuArray(zeros([length(v) length(u)],'single'));

%       u_small = gpuArray(u(1:length(u)/division_num)); du = u_small(2)-u_small(1);
%       v_small = gpuArray(v(1:length(u)/division_num)); dv = du;
%      
%       ddd = gpuArray((single([0:division_num-1])));
%       uu_small = repmat(u_small,size(v_small.'));  vv_small=repmat(v_small',size(u_small));
%       tempx  = repmat(ddd,size(ddd.')); tempy=repmat(ddd',size(ddd));    

kz_mat = real(sqrt(complex(n_material.^2./lambda^2-repmat(u,size(v.')).^2 - repmat(v',size(u)).^2)));  
for z_cnt = 1:1:z_num    
 z_map = find(z_p==z_cnt);
 z_value = zz(z_cnt);
 
theta_limit = min(atand(Nx*px/abs(z_value)),theta_limit_max);

 if length(z_map) ~= 0
%  H_z = exp(- j * 2 * pi * real(sqrt(complex(n_material.^2./lambda^2-repmat(u,size(v.')).^2 - repmat(v',size(u)).^2))) * (-z_value)).*(sqrt(repmat(u,size(v.')).^2+repmat(v',size(u)).^2) < sind(theta_limit)/lambda);
 uv_map = gpuArray(zeros([length(v) length(u)],'single')); 
 

H_z = (exp(-j*2*pi*(kz_mat)*(-z_value)).*(repmat(u,size(v.')).^2+repmat(v',size(u)).^2 < (sind(theta_limit)/lambda)^2));
% H_z2 = (exp(-j*2*pi*(kz_mat)*(-z_value)).*(n_material.^2./lambda^2-kz_mat.^2 < (sind(theta_limit)/lambda)^2));
 disp([' uv_cnt ' num2str(countuv) '/' num2str(GPU_division_num^2) ' z_cnt: ' num2str(z_cnt) '/' num2str(z_num) '  point_num:' num2str(length(z_map))]); 
 
 
 for p_cnt = 1:length(z_map)
%      x00 = xx(x_p(z_map(p_cnt))); y00 = yy(y_p(z_map(p_cnt)));
%      uv_map_small = exp(-j*2*pi* (x00 * uu_small + y00 * vv_small)+j*2*pi*rand_array(cnt));      
%      temp = exp(-j*2*pi* (x00*du*length(u_small)*tempx + y00*dv*length(v_small)*tempy));
%      uv_map = uv_map + kron(temp,uv_map_small);    
     
     x00 = xx(x_p(z_map(p_cnt))); y00 = yy(y_p(z_map(p_cnt)));
     UU = exp(-j*2*pi* (x00 * u)+j*2*pi*rand_array(cnt)); VV = exp(-j*2*pi* (y00 * v)).';
     uv_map = uv_map + UU.*VV;
     cnt = cnt + 1 ;
 end
%       disp(['  "testing calculation time : ' num2str(etime(clock,t5))]);
  mini_map = mini_map + uv_map.*H_z;
end     
end

if CPU_over == 0
ex_map(vv_range+filter_size, uu_range+filter_size) = gather(mini_map);
elseif CPU_over == 1
bin_write(gather(mini_map),filename,[2*filter_size 2*filter_size],[vv_range(1)+filter_size uu_range(1)+filter_size]);     
% m.ex_map(vv_range+filter_size, uu_range+filter_size) = gather(mini_map);
end    

end
countuv = countuv + 1; cnt = 1;

    end
end

g = gpuDevice(1);
reset(g);
y_range = ex_Ny/2-Ny/2+1:ex_Ny/2+Ny/2;   x_range = ex_Nx/2-Nx/2+1:ex_Nx/2+Nx/2;

%% 분할 FFT 도입하자
 if Nx*2 <= 60000 % 60k보다 작으면 그냥 CPU FFT로 분할없이 계산
  disp(['       division_num : 1' ]);
  ex_map = fftshift(ifft2(ifftshift(padarray(ex_map,double([pad_num pad_num])))));
  complex_sum = ex_map(y_range,x_range);
 else             % CPU 메모리 터질땐 GPU 분할 계산
decision_factor = GPU_max_Nx;
div_num = 2^ceil(log2((2*filter_size)^2/(decision_factor*1.2)^2));
div_num = find_good_div_num(div_num,2*filter_size);

if CPU_over == 0
complex_temp = zeros(length(y_range),2*filter_size);
else
bin_create_zero(length(y_range)*2*filter_size,filename2);    
end

disp(['       division_num : ' num2str(div_num)]);
t3=clock;
for cnt1 = 1:1:div_num
disp(['       Iteration part 1 : ' num2str(cnt1) '/' num2str(div_num)]);
Nx_div =  2*filter_size/(div_num);
if CPU_over == 0
temp = fftshift(ifft(ifftshift(padarray(gpuArray(ex_map(:,Nx_div*(cnt1-1)+1:Nx_div*cnt1)),[pad_num 0]),1)),1);
complex_temp(:,Nx_div*(cnt1-1)+1:Nx_div*cnt1) = gather(temp(y_range,:));
elseif CPU_over == 1
temp = bin_read(filename,[2*filter_size 2*filter_size],[2*filter_size length(Nx_div*(cnt1-1)+1:Nx_div*cnt1)],[1 Nx_div*(cnt1-1)+1]); 
temp = fftshift(  ifft(  ifftshift(  padarray(  gpuArray(temp)  ,[pad_num 0])  ,1)  )  ,1);
bin_write(gather(temp(y_range,:)),filename2,[length(y_range),2*filter_size],[1 Nx_div*(cnt1-1)+1]);     
end    
end
%%
if CPU_over == 0
clear ex_map; 
elseif CPU_over == 1
bin_delete(filename);
end

decision_factor = GPU_max_Nx;
div_num = 2^ceil(log2((2*filter_size)^2/(decision_factor*1.2)^2));
div_num = find_good_div_num(div_num,Nx);

%%
if Nx <= CPU_max_Nx*2
complex_sum = zeros(length(y_range),length(x_range));
else
complex_sum = 'not used';
filename3 = 'complex_sum';  bin_delete(filename3);
bin_create_zero(length(y_range)*length(x_range),filename3);
end
 
for cnt1 = 1:1:div_num
disp(['       Iteration part 2 : ' num2str(cnt1) '/' num2str(div_num)]);
Nx_div =   Nx/(div_num);
if CPU_over == 0
temp = fftshift(ifft(ifftshift(padarray(gpuArray(complex_temp(Nx_div*(cnt1-1)+1:Nx_div*cnt1,:)).',[pad_num 0]),1)),1).';
elseif CPU_over == 1
% temp = m2.complex_temp(Nx_div*(cnt1-1)+1:Nx_div*cnt1,:);     
temp = bin_read(filename2,[length(y_range),2*filter_size],[length(Nx_div*(cnt1-1)+1:Nx_div*cnt1) 2*filter_size],[Nx_div*(cnt1-1)+1 1]); 
temp = fftshift(ifft(ifftshift(padarray(gpuArray(temp).',[pad_num 0]),1)),1).';
end

if Nx <= CPU_max_Nx*2
complex_sum(Nx_div*(cnt1-1)+1:Nx_div*cnt1,:) = gather(temp(:,x_range));
else
bin_write(gather(temp(:,x_range)),filename3,[length(y_range),length(x_range)],[Nx_div*(cnt1-1)+1 1]);     
end

end

if CPU_over == 0
elseif CPU_over == 1
% bin_delete(filename2);
end

 disp(['  "Loop 1&2" calculation time : ' num2str(etime(clock,t3))]);
 end
