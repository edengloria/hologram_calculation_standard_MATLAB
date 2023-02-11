function Hologram = Double_Fresnel_transfer_GPU_Reconstructed(input_data,expansion_factor,xx,yy,theta_ref,phi_ref,virtual_propagation,z_propagation,ox,oy,filter_diameter,xymap_before_or_after)
%% ARSS Fresnel Diffraction + Fresnel Diffraction

%   자세한 설명 위치
global lambda px py Nx Ny k0 SLM_px SLM_py mm;

size_x = Nx*px; size_y = Ny*py;
size_h = Nx*SLM_px;

standard_propagation = abs(virtual_propagation + z_propagation)*size_h/(size_h+size_x);
z_propagation = min(z_propagation, standard_propagation);

pv = lambda*z_propagation/Nx/SLM_px;
s = pv/px;

x_map = repmat(xx,size(yy.'));  y_map = repmat(yy.',size(xx));

ox = -ox;  oy= -oy;%코드상 부호 바꾸어야 우리가 생각하는 +x +y 방향임.


%% Fresnel Propagation

NN = max(Nx,Ny); % symmetric 한정
ex_NN = NN*expansion_factor;

xx_v = linspace(-pv*Nx/2,+pv*Nx/2,Nx);
yy_v = linspace(-pv*Ny/2,+pv*Ny/2,Ny);

if strcmp(xymap_before_or_after, 'after')  
xx = lambda*z_propagation/(xx_v(2)-xx_v(1)).^2/2/NN * xx_v;
yy = lambda*z_propagation/(yy_v(2)-yy_v(1)).^2/2/NN * yy_v;
end
uu = xx/lambda/z_propagation; vv = yy/lambda/z_propagation;

du = uu(2)-uu(1); dv = vv(2)-vv(1);
ex_dx = 1/ex_NN/du; ex_dy = 1/ex_NN/dv;

ex_xx = single(ex_dx*[-ex_NN/2+1:ex_NN/2]);
ex_yy = single(ex_dy*[-ex_NN/2+1:ex_NN/2]);

map = input_data.*exp(+1j*2*pi/lambda*z_propagation).*exp(+1j*pi*lambda*z_propagation*(repmat(uu,size(vv.')).^2+repmat(vv.',size(uu)).^2));
ex_map = padarray(gpuArray(map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]); clear map;


%  t5 = clock  ;
% ex_map = fftshift(ifft2(ifftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
ex_map = ifftshift(fft2(fftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
% disp(['  "fft" calculation time : ' num2str(etime(clock,t5))]);
ex_map = ex_map.*exp(+1j*pi*(repmat(ex_xx,size(ex_yy.')).^2+repmat(ex_yy.',size(ex_xx)).^2)/lambda/z_propagation);  

 y_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;   x_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;
% figure(67)
% imagesc(real(ex_map)); axis xy; 
 filter_plane_light = gather(ex_map(y_range, x_range));
 new_xx = ex_xx(x_range);  new_yy = ex_yy(y_range);
 
%  px = new_xx(2)-new_xx(1);
%  py = new_yy(2)-new_yy(1);

figure(22)
imagesc(abs(filter_plane_light));

%% Iris Filter - 사입사 Reference(plane)을 고려하여 설계

% kx0 = single(k0*sind(theta_ref)*cosd(phi_ref));
% ky0 = single(k0*sind(theta_ref)*sind(phi_ref));

x_vmap = repmat(xx_v,size(yy_v.'));  y_vmap = repmat(yy_v.',size(xx_v));

Iris_Filter = (x_vmap - tand(theta_ref)*cosd(phi_ref)*z_propagation).^2 + (y_vmap - tand(theta_ref)*sind(phi_ref)*z_propagation).^2 <= (filter_diameter/2)^2;

filter_plane_light = filter_plane_light.*Iris_Filter;

figure(23)
imagesc(Iris_Filter);
figure(24)
imagesc(abs(filter_plane_light));
figure(25)
imagesc(angle(filter_plane_light));

%% ARSS Fresnel Diffraction

% filter_plane_light = filter_plane_light.*exp(+1j*pi*((s*x_map).^2+(s*y_map).^2)/lambda/ (virtual_propagation));

phi_u = exp(-1j*pi*((s^2-s)*x_vmap.^2-2*s*ox*x_vmap + (s^2-s)*y_vmap.^2-2*s*oy*y_vmap)/lambda/ (virtual_propagation));

if lambda*abs(virtual_propagation)/px/(2*abs(s^2-s))/px  < Nx
m1_filter =  sqrt((x_vmap-ox/(s-1)).^2 + (y_vmap-oy/(s-1)).^2) <= lambda*abs(virtual_propagation)/px/(2*abs(s^2-s))     *1.2  ;
phi_u = phi_u.*m1_filter;
end



phi_h = exp(-1j*pi*s*(x_vmap.^2 + y_vmap.^2)/lambda/ (virtual_propagation));

if lambda*abs(virtual_propagation)/px/2/s/px  < Nx
mh_filter = (x_vmap).^2 + (y_vmap).^2 <= (lambda*abs(virtual_propagation)/px/2/s          *1.2  ).^2;
phi_h = phi_h.*mh_filter;
end


Cz  = (exp(-1j*pi*(2/lambda* (virtual_propagation) + 1/lambda/ (virtual_propagation)*((1-s)*(x_vmap.^2 + y_vmap.^2) +2*(ox*x_vmap + oy*y_vmap) + ox^2+oy^2)  ))/(-1j*lambda* (virtual_propagation)))./(-1j*lambda* (virtual_propagation));

if  lambda*abs(virtual_propagation)/px/2/abs(1-s)/px  < Nx
m2_filter = sqrt((x_vmap-ox/(s-1)).^2 + (y_vmap-oy/(s-1)).^2) <= lambda*abs(virtual_propagation)/px/2/abs(1-s)          *1.2   ;
Cz = Cz.*m2_filter;
end

Hologram = Cz.*ifftshift(ifft2(fft2(filter_plane_light.*phi_u) .* fft2(phi_h)));

% Hologram = virtual_plane_light;

% figure(20)
% imagesc(abs(virtual_plane_light));
% figure(21)
% imagesc(angle(virtual_plane_light))






end


% function Hologram = Double_Fresnel_transfer_GPU_Reconstructed(input_data,expansion_factor,theta_recon,phi_recon,virtual_propagation,z_propagation,filter_diameter,symmetry_mode, n_material)
% %%
%  t3=clock; % 재생 파트 시간 계산
% global lambda px py Nx Ny SLM_px SLM_py k0;
% 
% if symmetry_mode == 1
%         NN = max(Nx,Ny);   Nx = NN; Ny = NN;
% end
% 
% 
% ex_Nx = Nx*expansion_factor; ex_Ny = Ny*expansion_factor; % num of pixel
% ex_size_x = ex_Nx*px;  ex_size_y = ex_Nx*py; % hologram size
% ex_dfx = 1/ex_size_x; ex_dfy = 1/ex_size_y;
% 
% xx_small = single(SLM_px*[-Nx/2+1:Nx/2]); yy_small = single(SLM_py*[-Ny/2+1:Ny/2]);
% 
% %% Propagation
% if theta_recon ~= 0   
%    kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
%    ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);
%    
%    ex_map = input_data.*exp(-1j*(kx_recon*repmat(xx_small,size(yy_small.'))+ky_recon*repmat(yy_small.',size(xx_small))  ));  % 사입사한다
%    ex_map = padarray(gpuArray(ex_map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]);
% else
%    ex_map = padarray(gpuArray(input_data), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]);
% end 
% 
% u = single(ex_dfx*[-ex_Nx/2+1:ex_Nx/2]);
% v = single(ex_dfy*[-ex_Ny/2+1:ex_Ny/2]);
% 
% fftu = fftshift(u); fftv = fftshift(v);
% fft_uu = repmat(fftu,size(fftv.'));  fft_vv=repmat(fftv',size(fftu));
% 
%   ex_map = fft2(ex_map);
%  
%  ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-(fft_uu).^2 - (fft_vv).^2)));% 2019-11-25 수정됨 real 추가 NAN 발생문제 해결
%  ex_map = ex_map.*exp(-1j * 2 * pi * ex_ww * z_propagation);
%  clear ex_ww;
% 
%  ex_map = ifft2(ex_map);
%  
%  y_range = ex_Ny/2-Ny/2+1:ex_Ny/2+Ny/2;   x_range = ex_Nx/2-Nx/2+1:ex_Nx/2+Nx/2;
%  filter_plane_light = gather(ex_map(y_range, x_range));
%  
% disp(['  "Expanded transfer" calculation time : ' num2str(etime(clock,t3))]);
% 
% imagesc(abs(filter_plane_light));
% %% Iris Filter - 사입사 Reference(plane)을 고려하여 설계
% % xymap_before_or_after = 'before'
% xx_filter = lambda*z_propagation/NN/SLM_px* xx_small;
% yy_filter = lambda*z_propagation/NN/SLM_py* yy_small;
% 
% x_map = repmat(xx_filter, size(yy_filter.')); y_map = repmat(yy_filter.',size(xx_filter));
% 
% kx0 = single(k0*sind(theta_recon)*cosd(phi_recon));
% ky0 = single(k0*sind(theta_recon)*sind(phi_recon));
% 
% Iris_Filter = ((x_map - kx0/sqrt(k0^2-kx0^2-ky0^2)*z_propagation).^2 + (y_map - ky0/sqrt(k0^2-kx0^2-ky0^2)*z_propagation).^2) <= (filter_diameter/2)^2;
% 
% filter_plane_light = filter_plane_light.*Iris_Filter;
% 
% %% Propagation
% if theta_recon ~= 0  
%    kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
%    ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);
%  
%    ex_map = filter_plane_light.*exp(-1j*(kx_recon*repmat(xx,size(yy.'))+ky_recon*repmat(yy.',size(xx))  ));  % 사입사한다
%    ex_map = padarray(gpuArray(ex_map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]);
% else
%    ex_map = padarray(gpuArray(filter_plane_light), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]);
% end 
% 
% u = single(ex_dfx*[-ex_Nx/2+1:ex_Nx/2]);
% v = single(ex_dfy*[-ex_Ny/2+1:ex_Ny/2]);
% 
% fftu = fftshift(u); fftv = fftshift(v);
% fft_uu = repmat(fftu,size(fftv.'));  fft_vv=repmat(fftv',size(fftu));
% 
%   ex_map = fft2(ex_map);
%  
%  ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-(fft_uu).^2 - (fft_vv).^2)));% 2019-11-25 수정됨 real 추가 NAN 발생문제 해결
%  ex_map = ex_map.*exp(-1j * 2 * pi * ex_ww * virtual_propagation);
%  clear ex_ww;
% 
%  ex_map = ifft2(ex_map);
%  
%  y_range = ex_Ny/2-Ny/2+1:ex_Ny/2+Ny/2;   x_range = ex_Nx/2-Nx/2+1:ex_Nx/2+Nx/2;
%  Hologram = gather(ex_map(y_range, x_range));
%  
% disp(['  "Expanded transfer" calculation time : ' num2str(etime(clock,t3))]);
