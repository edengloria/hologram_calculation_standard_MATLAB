%% 확대 파트 lens 응용
if magnification_factor == 1
%      CGH_pattern_out =  CGH_pattern; % do nothing
else  
% f_lense = -magnification_factor*image_center/(magnification_factor-1);
%  filter_size = floor(sqrt(filter^2*f_lense_final^2/k0^2)/px);
%  figure(121)
%  imagesc(angle(exp(j*pi*((x-shift_x).^2 + (y-shift_y).^2)/lambda/f_lense_final)).*(sqrt((x-shift_x).^2 + (y-shift_y).^2) < filter_size*px/2));
% axis xy;



%  complex_sum = complex_sum.*exp(j*pi*((x-shift_x).^2 + (y-shift_y).^2)/lambda/f_lense_final).*(sqrt((x-shift_x).^2 + (y-shift_y).^2) < filter_size*px/2); %상을 확대시킴 magnification_factor만큼
complex_temp = complex_sum_backup.*exp(j*pi*((x-shift_x).^2 + (y-shift_y).^2)/lambda/f_lense_final); %상을 확대시킴 magnification_factor만큼
% complex_sum = complex_sum.*exp(j*pi*((x).^2 + (y).^2)/lambda/f_lense_final).*exp(-j*(kx_shift*x+ky_shift*y)); %상을 확대시킴 magnification_factor만큼
end
