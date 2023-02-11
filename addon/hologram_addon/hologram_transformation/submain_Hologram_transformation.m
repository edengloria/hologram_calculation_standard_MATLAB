% CGH_pattern = complex_sum;

%% 회전변환 파트
if theta_x == 0 & theta_y == 0 & theta_z == 0;
else
shift_xyz = [0 0 -image_center];
complex_sum = hologram_shift_spatial_domain(complex_sum,shift_xyz);

t1=clock; % 
complex_sum = rotational_transformation_test(complex_sum,theta_x,theta_y,theta_z,x,y); % z방향 반대로 돔           
disp(['  "Rotational_transformation" calculation time : ' num2str(etime(clock,t1))]); 

shift_xyz = [0 0 image_center];
complex_sum = hologram_shift_spatial_domain(complex_sum,shift_xyz);

% complex_sum = CGH_pattern_RT;
end

%% 확대 파트 lens 응용
if magnification_factor == 1
%      CGH_pattern_out =  CGH_pattern; % do nothing
else  
f_lense = -magnification_factor*image_center/(magnification_factor-1);
% shift_x = px*Nx/2;   shift_y = 0*mm;  
figure(121)
imagesc(angle(exp(j*pi*((x-shift_x).^2 + (y-shift_y).^2)/lambda/f_lense)));
axis xy;
complex_sum = complex_sum.*exp(j*pi*((x-shift_x).^2 + (y-shift_y).^2)/lambda/f_lense); %상을 확대시킴 magnification_factor만큼
image_center = image_center * magnification_factor;
end

%% object_rotation_part 
 if shift_x == 0 & shift_y == 0 ;
     theta_shift = 0; phi_shift = 0;
 else
 theta_shift = atand(sqrt(shift_x^2+shift_y^2)/image_center);  phi_shift = atand(shift_y/shift_x);    
% kx_shift = 2*pi/lambda*sind(theta_shift)*cosd(phi_shift);
% ky_shift = 2*pi/lambda*sind(theta_shift)*sind(phi_shift);
% % shift_xyz = [shift_x shift_y 0];
% complex_sum = complex_sum.*exp(-j*(kx_shift*x + ky_shift*y)); 
end
% complex_sum = CGH_pattern;