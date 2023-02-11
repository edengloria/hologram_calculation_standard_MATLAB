        d_view = 'off';
        
switch calculation_type
    case 'point_cloud' 
        filter = pi/px*0.95; % point cloud 초점이 동그랗게 안모이면 이 값을 줄여라. 단 시야각은 감소한다. Nx늘려도 좋아질 수 있음. limit은 pi/px          
        complex_sum = pointcloud_2_CGH(point_array,d_view,filter,xx,yy,point_transfer_method,z_num);  
    case 'Fourier_plane'
        complex_sum = plane_2_CGH(fmap,d_view,image_center_,xx,yy,propagation_type,random_phase_switch,virtual_center,DF_image_scale, DF_intensity_scale); clear fmap;         
end




%% 사입사를 맨 나중에 부여하자 - CPU RAM 초과 버전
if strcmp(complex_sum,'not used') == 1
filename3 = 'complex_sum';
filename4 = filename_save;  

decision_factor = CPU_max_Nx;
div_num = 2^ceil(log2((Nx)^2/(decision_factor*1.2)^2));
div_num = find_good_div_num(div_num,Nx);

bin_create_zero(Ny*Nx,filename4);    

switch ref_cond
    case 'plane'       
for cnt1 = 1:1:div_num        
disp(['       Iteration part 3(off axis) : ' num2str(cnt1) '/' num2str(div_num)]);
Nx_div =   Nx/(div_num);
y_range = Nx_div*(cnt1-1)+1:Nx_div*cnt1;  x_range = 1:Nx;

temp = bin_read(filename3,[Ny,Nx],[length(y_range) Nx],[Nx_div*(cnt1-1)+1 1]); 

     kx0 = single(k0*sind(theta_ref)*cosd(phi_ref));
     ky0 = single(k0*sind(theta_ref)*sind(phi_ref));
%      phase_ref = -kx0*repmat(xx,size(yy.'))-ky0*repmat(yy.',size(xx));     
temp = temp.*exp(-j*(-kx0*repmat(xx,size(yy(y_range).'))-ky0*repmat(yy(y_range).',size(xx))));
bin_write(temp,filename4,[Ny,Nx],[Nx_div*(cnt1-1)+1 1]);     
end
    case 'point'
for cnt1 = 1:1:div_num        
disp(['       Iteration part 3(off axis) : ' num2str(cnt1) '/' num2str(div_num)]);
Nx_div =   Nx/(div_num);
y_range = Nx_div*(cnt1-1)+1:Nx_div*cnt1;  x_range = 1:Nx;

temp = bin_read(filename3,[Ny,Nx],[length(y_range) Nx],[Nx_div*(cnt1-1)+1 1]); 
% phase_ref = -k0*sqrt((repmat(xx,size(yy(y_range).'))-x00).^2 + (repmat(yy(y_range).',size(xx))-y00).^2 + z00.^2); 
temp = temp.*exp(-j*(-k0*sqrt((repmat(xx,size(yy(y_range).'))-x00).^2 + (repmat(yy(y_range).',size(xx))-y00).^2 + z00.^2)));

bin_write(temp,filename4,[Ny,Nx],[Nx_div*(cnt1-1)+1 1]);     
end
end 
    
%% CPU RAM 정상 버전        
else
%% complex_sum 저장 (분할본, 사입사도 미적용)
if magnification_factor ~= 1
filename = ['Partial_' num2str(object_root) '_' num2str(px/um) 'um_' num2str(Nx) 'Nx_' num2str(magnification_factor) '배_' num2str(image_reduction_factor) '(크기)_' num2str(image_center) '(위치)_' num2str(point_reduction_factor) '(줄인점배율)' '.mat'];
save(filename,'complex_sum','px','py','lambda','Nx','Ny','theta_ref','phi_ref','image_center','-v7.3','-nocompression');
end
%% Hologram upscailing : 물체를 작게 만들어서 렌즈함수로 확대한다. magnification_factor = 1 이면 알아서 아무것도 안함
if magnification_factor ~= 1
    more_division_num = 4;
    complex_sum = function_Hologram_upscailing_magnification(magnification_factor,complex_sum,xx,yy,f_lense_final,more_division_num);
    image_center = image_center * magnification_factor;
    Nx = Nx*magnification_factor;
    Ny = Ny*magnification_factor;
    prepare_xx_yy_dfx_uu_vv; 
end
%% Lens_multiplication_on_CGH
% Lens_multiplication_on_CGH = 40*1e-2;
Lens_multiplication_on_CGH = 0;
if Lens_multiplication_on_CGH ~= 0
    carrier_phase_map = pi*(repmat(xx,size(yy.')).^2+repmat(yy.',size(xx)).^2)/lambda/Lens_multiplication_on_CGH; 
    complex_sum = complex_sum.*exp(j*carrier_phase_map);  
end

%% 사입사를 맨 나중에 부여하자
switch ref_cond
    case 'plane'
if theta_ref ~= 0
     kx0 = single(k0*sind(theta_ref)*cosd(phi_ref));
     ky0 = single(k0*sind(theta_ref)*sind(phi_ref));
     phase_ref = -kx0*repmat(xx,size(yy.'))-ky0*repmat(yy.',size(xx));
     complex_sum = complex_sum.*exp(-j*phase_ref); 
     clear phase_ref;
end
    case 'point'
    phase_ref = -k0*sqrt((repmat(xx,size(yy.'))-x00).^2 + (repmat(yy.',size(xx))-y00).^2 + z00.^2);  
    complex_sum = complex_sum.*exp(-j*phase_ref);
    clear phase_ref;
end
end