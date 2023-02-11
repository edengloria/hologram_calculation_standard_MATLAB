div_cond = 14000;    
 dzz_ = 0.2*mm;
% dzz_ = 2.4*mm;     
if z_num == 1
     zz = mean(point_array(3,:));
     dzz = dzz_;
else
     zz =  linspace(min(point_array(3,:)),max(point_array(3,:)),z_num); 
     dzz = zz(2)-zz(1);
end    
     
     
complex_sum = zeros(Ny,Nx,'single');
point_number = size(point_array,2);                      
image_center = zz(1)-dzz;

%% 가까운 점으로 매핑하고, 중복되는 점은 지운다
[x_p, y_p, z_p] = mapping_and_erasing_points(xx,yy,zz,point_array,point_number);
system_angle_limit = double(max(atand(sqrt((abs(xx(x_p))+xx(end)).^2+(abs(yy(y_p))+yy(end)).^2)./zz(z_p))))+2;
disp(['       system_angle_limit (degree) : ' num2str(system_angle_limit)]); %주어진 홀로그램 상을 만들기 위해서 필요한 최대 각도 성분을 알려준다.
     
%%
clear point_array;

for z_cnt = 1:1:z_num  
  z_map_length(z_cnt) =  length(find(z_p==z_cnt));
end
 ispoint_z = find(z_map_length);

 
 cnt = length(ispoint_z);
for z_cnt = z_num:-1:1  
  z_map = find(z_p==z_cnt);
  xy_map = zeros(Ny,Nx,'single');

 if z_map_length(z_cnt) ~= 0           
                      
     
     if cnt ~= 1
     z_pro = zz(ispoint_z(cnt))-zz(ispoint_z(cnt-1));
     elseif cnt == 1
     z_pro = dzz;
     end
     
     
     for p_cnt = 1:length(z_map)
     xy_map(y_p(z_map(p_cnt)),x_p(z_map(p_cnt))) = exp(j*2*pi*rand('single'));
     end  


     complex_sum = complex_sum + xy_map;
     clear xy_map;
     [division_num w_num] = calculate_dnum_wnum_SFT(div_cond,z_pro);
     disp(['        z_cnt: ' num2str(z_cnt) '/' num2str(z_num) '     w_num: ' num2str(w_num)]);   
     complex_sum = short_transfer_GPU(complex_sum,-z_pro,0,0,division_num,w_num) ;      
     cnt = cnt - 1;
 end
 
end

%   if Nx >= 50000 % 안전빵으로 저장해두자
%   filename = ['temporary_data'];
%   save(filename,'complex_sum','px','py','lambda','Nx','Ny','image_center','-v7.3','-nocompression');
%   end

%   figure(123)
%   imagesc(abs(complex_sum));
 
 

complex_sum = expanded_transfer_GPU_n(complex_sum, 2, 0, 0, 0, 0, -image_center, 1,1) ;

%%

% div_cond = 18000;
%   div_dis = dzz_;

% [division_num w_num] = calculate_dnum_wnum_SFT(div_cond,dzz_); 
%  while image_center >= dzz_
%  image_center
%      complex_sum = short_transfer_GPU(complex_sum,-dzz_,0,0,division_num,w_num) ;   
%  image_center = image_center - dzz;
%  end
%  image_center
%  complex_sum = short_transfer_GPU(complex_sum,-image_center,0,0,division_num,w_num) ;   
%  
 %% 사입사 제공하는 부분이다.
%  phase_ref = -kx0*repmat(xx,size(yy.'))-ky0*repmat(yy.',size(xx));
%  complex_sum = complex_sum.*exp(-j*phase_ref); 