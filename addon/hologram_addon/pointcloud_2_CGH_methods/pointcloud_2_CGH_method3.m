[x y] = meshgrid(xx,yy);

complex_sum = zeros(Ny,Nx,'single');    
point_number = size(point_array,2);  
depth_z = max(point_array(3,:))-min(point_array(3,:));
temp_plane = min(point_array(3,:)) - 0.1*depth_z;
image_center = temp_plane;

for p_cnt = 1:1:point_number
    [dumy, x_p(p_cnt)]=min(abs(xx-point_array(1,p_cnt)));
    [dumy, y_p(p_cnt)]=min(abs(yy-point_array(2,p_cnt)));
%     filter_size(p_cnt)=floor(sqrt(filter^2*point_array(3,p_cnt)^2/k0^2)/px);
end

%zdiff_im_center = point_array(3,:);
 zdiff_im_center = point_array(3,:)-image_center;
filter_size_max=floor(sqrt(filter^2*max(abs(zdiff_im_center))^2/k0^2)/px); %filter_size_max 가 Nx/2 보다 더 크다면 이 방법은 속도 개선효과 없음. 더 느릴수도

xx_add = single(px*[-filter_size_max:1:filter_size_max]);
yy_add = single(py*[-filter_size_max:1:filter_size_max]);
[x_add, y_add] = meshgrid(xx_add,yy_add);
% phase_ref = -kx0*x_add-ky0*y_add;



for p_cnt = 1:1:point_number
    p_cnt
     y_start = max(y_p(p_cnt)-filter_size_max,1); y_end = min(y_p(p_cnt)+filter_size_max,Ny); y_dif_L = max(1-y_p(p_cnt)+filter_size_max,0); y_dif_R = max(y_p(p_cnt)+filter_size_max-Ny,0); 
     x_start = max(x_p(p_cnt)-filter_size_max,1); x_end = min(x_p(p_cnt)+filter_size_max,Nx); x_dif_L = max(1-x_p(p_cnt)+filter_size_max,0); x_dif_R = max(x_p(p_cnt)+filter_size_max-Nx,0);      

     amplitude_filtered = 1/zdiff_im_center(p_cnt).*((x_add).^2+(y_add).^2<=filter^2*zdiff_im_center(p_cnt)^2/k0^2);
     phase  = k0*( (x_add).^2/2/zdiff_im_center(p_cnt) + (y_add).^2/2/zdiff_im_center(p_cnt))+2*pi*rand('single');
     complex_sum(y_start:y_end, x_start:x_end) = complex_sum(y_start:y_end, x_start:x_end) + amplitude_filtered(1+y_dif_L:end-y_dif_R,1+x_dif_L:end-x_dif_R).*exp(j*(phase(1+y_dif_L:end-y_dif_R,1+x_dif_L:end-x_dif_R)));

end
complex_sum = expanded_transfer_GPU(complex_sum, 2, 0, 0, 0, 0, -image_center, 1) ;

% phase_ref = -kx0*x-ky0*y;
% complex_sum = complex_sum.*exp(-j*phase_ref);
