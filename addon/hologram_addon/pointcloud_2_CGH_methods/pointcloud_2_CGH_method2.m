
if z_num == 1
     zz = mean(point_array(3,:));
else
     zz =  linspace(min(point_array(3,:)),max(point_array(3,:)),z_num); 
end 

complex_sum = zeros(Ny,Nx,'single');
point_number = size(point_array,2);                      

%% 가까운 점으로 매핑하고, 중복되는 점은 지운다
[x_p, y_p, z_p] = mapping_and_erasing_points(xx,yy,zz,point_array,point_number);
system_angle_limit = double(max(atand(sqrt((abs(xx(x_p))+xx(end)).^2+(abs(yy(y_p))+yy(end)).^2)./zz(z_p))))+2;
disp(['       system_angle_limit (degree) : ' num2str(system_angle_limit)]); %주어진 홀로그램 상을 만들기 위해서 필요한 최대 각도 성분을 알려준다.
     
%%



for z_cnt = 1:1:z_num    
 z_map = find(z_p==z_cnt);
 z_value = zz(z_cnt);
 xy_map = zeros(Ny,Nx,'single');
 
 if length(z_map) ~= 0
     disp(['        z_cnt: ' num2str(z_cnt) '/' num2str(z_num)]);
 for p_cnt = 1:length(z_map)
     xy_map(y_p(z_map(p_cnt)),x_p(z_map(p_cnt))) = exp(j*2*pi*rand('single'));
 end
     filter_size = floor(sqrt(filter^2*z_value^2/k0^2)/px);
     
     xx_add = single(px*[-filter_size:1:filter_size]);
     yy_add = single(py*[-filter_size:1:filter_size]);
     [x_add, y_add] = meshgrid(xx_add,yy_add);
     
%      phase_ref = -kx0*x_add-ky0*y_add;
     amplitude_filtered = 1/z_value.*((x_add).^2+(y_add).^2<=filter^2*z_value^2/k0^2);
     phase  = k0*( (x_add).^2/2/z_value + (y_add).^2/2/z_value);
%      comp_temp = amplitude_filtered.*exp(j*(phase-phase_ref));
     comp_temp = amplitude_filtered.*exp(j*(phase));
     complex_sum = complex_sum + conv2(xy_map,comp_temp,'same');
 end    
 
end
 
%%
     