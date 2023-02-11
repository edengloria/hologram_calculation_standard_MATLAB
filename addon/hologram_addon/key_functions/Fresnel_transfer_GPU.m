function [complex_sum new_px new_py] = Fresnel_transfer_GPU(input_data, xx, yy, theta_recon, phi_recon, z_propagation, xymap_before_or_after,expansion_factor)
%% 20200715: 드디어 성공.. Fresnel approximation 하에서 홀로그램 계산은 fft를 한번만 수행해도 된다. 
 % ASM은 propagation 전후 xy맵의 크기가 안바뀌지만 이녀석은 propagation 거리에 따라 xy맵이 바뀌는게 특징이다.
 % xymap_before_or_after = 'before' 이면 xx,yy 입력은 프레넬 전파 전 기준이다.
 % xymap_before_or_after = 'after' 이면 xx,yy 입력은 프레넬 전파 후 기준이다. (CGH를 계산해낼때 용이)
%%
global lambda px py Nx Ny Ideal_angle_limit;

NN = max(Nx,Ny); % symmetric 한정
ex_NN = NN*expansion_factor; 
%% Diverging propagation
if z_propagation >= 0 
if strcmp(xymap_before_or_after, 'after')   
xx = lambda*z_propagation/(xx(2)-xx(1)).^2/ex_NN * xx;
yy = lambda*z_propagation/(yy(2)-yy(1)).^2/ex_NN * yy;
end    

% dx = px; dy = py;
dx = xx(2)-xx(1); dy = yy(2) - yy(1);

ex_size_x = ex_NN*dx;
ex_size_y = ex_NN*dy; % hologram size
ex_dfx = 1/ex_size_x; ex_dfy = 1/ex_size_y;

ex_uu =  (ex_dfx*[-ex_NN/2+1/2:ex_NN/2-1/2]);
ex_vv =  (ex_dfy*[-ex_NN/2+1/2:ex_NN/2-1/2]);    

if theta_recon ~= 0
kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);

input_data = input_data.*exp(-1j*(kx_recon*repmat(xx,size(yy.'))+ky_recon*repmat(yy.',size(xx))  ));  % 사입사한다
end

map = input_data.*exp(-1j*pi*(repmat(xx,size(yy.')).^2+repmat(yy.',size(xx)).^2)/lambda/z_propagation);        
ex_map = padarray(gpuArray(map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]); 


ex_map = fftshift(fft2(ifftshift(ex_map))); % 이론상으론 이게 맞는데... 상이 뒤집힘 (ex_transfer가 잘못되었나?)

%  ex_map = fftshift(ifft2(ifftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
ex_map = ex_map.*exp(-1j*pi*lambda*z_propagation*(repmat(ex_uu,size(ex_vv.')).^2+repmat(ex_vv.',size(ex_uu)).^2)).*exp(-1j*2*pi/lambda*z_propagation); %픽셀작을땐 이게오래걸림..
y_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;   x_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;
complex_sum = gather(ex_map(y_range, x_range));

new_px = (1/expansion_factor)* (ex_uu(2)-ex_uu(1))*lambda*z_propagation;
new_py = (1/expansion_factor)* (ex_vv(2)-ex_vv(1))*lambda*z_propagation;

% new_px = (ex_uu(2)-ex_uu(1))*lambda*z_propagation;
% new_py =  (ex_vv(2)-ex_vv(1))*lambda*z_propagation;
end
%% Converging propagation
if z_propagation <= 0
z_propagation = -z_propagation;

if strcmp(xymap_before_or_after, 'after')  
xx = lambda*z_propagation/(xx(2)-xx(1)).^2/ex_NN * xx;
yy = lambda*z_propagation/(yy(2)-yy(1)).^2/ex_NN  * yy;
end
uu = xx/lambda/z_propagation; vv = yy/lambda/z_propagation;

du = uu(2)-uu(1); dv = vv(2)-vv(1);
ex_dx = 1/ex_NN/du; ex_dy = 1/ex_NN/dv;

ex_xx =  (ex_dx*[-ex_NN/2+1/2:ex_NN/2-1/2]);
ex_yy =  (ex_dy*[-ex_NN/2+1/2:ex_NN/2-1/2]);

if theta_recon ~= 0
kx_recon = 2*pi/lambda*sind(theta_recon)*cosd(phi_recon);
ky_recon = 2*pi/lambda*sind(theta_recon)*sind(phi_recon);

input_data = input_data.*exp(-1j*(kx_recon*repmat(xx,size(yy.'))+ky_recon*repmat(yy.',size(xx))  ));  % 사입사한다
end

map = input_data.*exp(+1j*2*pi/lambda*z_propagation).*exp(+1j*pi*lambda*z_propagation*(repmat(uu,size(vv.')).^2+repmat(vv.',size(uu)).^2));
ex_map = padarray(gpuArray(map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]); clear map;

 
%  t5 = clock  ;
ex_map = fftshift(ifft2(ifftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
% ex_map = ifftshift(ifft2(fftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
% disp(['  "fft" calculation time : ' num2str(etime(clock,t5))]);
ex_map = ex_map.*exp(+1j*pi*(repmat(ex_xx,size(ex_yy.')).^2+repmat(ex_yy.',size(ex_xx)).^2)/lambda/z_propagation);  

 y_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;   x_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;
% figure(67)
% imagesc(real(ex_map)); axis xy; 
 complex_sum = gather(ex_map(y_range, x_range));
 new_px = (1/expansion_factor)*(ex_xx(2)-ex_xx(1));  new_py = (1/expansion_factor)*(ex_yy(2)-ex_yy(1)); %검토 필요
 
%  new_px = (ex_xx(2)-ex_xx(1));  new_py = (ex_yy(2)-ex_yy(1)); %검토 필요
 
end



end