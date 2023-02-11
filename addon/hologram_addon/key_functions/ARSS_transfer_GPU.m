function complex_sum = ARSS_transfer_GPU(input_data, xx, yy, z_propagation,s,ox,oy)
%% 20210713 "Aliasing-reduced Fresnel diffraction with scale and shift operation" 논문에 기재된 방법 구현해 보기

global lambda px py Nx Ny;

x_map = repmat(xx,size(yy.'));  y_map = repmat(yy.',size(xx));

ox = -ox;  oy= -oy;%코드상 부호 바꾸어야 우리가 생각하는 +x +y 방향임.

phi_u = exp(-j*pi*((s^2-s)*x_map.^2-2*s*ox*x_map + (s^2-s)*y_map.^2-2*s*oy*y_map)/lambda/ (z_propagation));

if lambda*abs(z_propagation)/px/(2*abs(s^2-s))/px  < Nx
m1_filter =  sqrt((x_map-ox/(s-1)).^2 + (y_map-oy/(s-1)).^2) <= lambda*abs(z_propagation)/px/(2*abs(s^2-s))     *1.2  ;
phi_u = phi_u.*m1_filter;
end



phi_h = exp(-j*pi*s*(x_map.^2 + y_map.^2)/lambda/ (z_propagation));

if lambda*abs(z_propagation)/px/2/s/px  < Nx
mh_filter = (x_map).^2 + (y_map).^2 <= (lambda*abs(z_propagation)/px/2/s          *1.2  ).^2;
phi_h = phi_h.*mh_filter;
end


Cz  = (exp(-j*pi*(2/lambda* (z_propagation) + 1/lambda/ (z_propagation)*((1-s)*(x_map.^2 + y_map.^2) +2*(ox*x_map + oy*y_map) + ox^2+oy^2)  ))/(-j*lambda* (z_propagation)))./(-j*lambda* (z_propagation));

if  lambda*abs(z_propagation)/px/2/abs(1-s)/px  < Nx
m2_filter = sqrt((x_map-ox/(s-1)).^2 + (y_map-oy/(s-1)).^2) <= lambda*abs(z_propagation)/px/2/abs(1-s)          *1.2   ;
Cz = Cz.*m2_filter;
end

complex_sum = Cz.*ifftshift(ifft2(fft2(input_data.*phi_u) .* fft2(phi_h)));

%  figure(3);
%  imagesc(abs(m2_filter ));
%  
%  figure(4);
% imagesc(real(phi_u ));

% figure(1)
% imagesc(abs(input_data));
% 
% figure(2)
% imagesc(abs(complex_sum));







%%   기존 Fresnel transfer 함수
% expansion_factor = 2; % 안바꿀듯
% global lambda px py Nx Ny Ideal_angle_limit;
% 
% NN = max(Nx,Ny); % symmetric 한정
% ex_NN = NN*expansion_factor; 
% %% Diverging propagation
% if z_propagation >= 0 
% if strcmp(xymap_before_or_after, 'after')   
% xx = lambda*z_propagation/(xx(2)-xx(1)).^2/ex_NN * xx;
% yy = lambda*z_propagation/(yy(2)-yy(1)).^2/ex_NN * yy;
% end    
%         
% dx = xx(2)-xx(1); dy = yy(2) - yy(1);
% 
% ex_size_x = ex_NN*dx;
% ex_size_y = ex_NN*dy; % hologram size
% ex_dfx = 1/ex_size_x; ex_dfy = 1/ex_size_y;
% 
% ex_uu = single(ex_dfx*[-ex_NN/2+1:ex_NN/2]);
% ex_vv = single(ex_dfy*[-ex_NN/2+1:ex_NN/2]);    
%     
% 
% map = input_data.*exp(-1j*pi*(repmat(xx,size(yy.')).^2+repmat(yy.',size(xx)).^2)/lambda/z_propagation);        
% ex_map = padarray(gpuArray(map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]); 
% 
% 
% ex_map = ifftshift(fft2(fftshift(ex_map))); % 이론상으론 이게 맞는데... 상이 뒤집힘 (ex_transfer가 잘못되었나?)
% 
% %  ex_map = fftshift(ifft2(ifftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
% ex_map = ex_map.*exp(-1j*pi*lambda*z_propagation*(repmat(ex_uu,size(ex_vv.')).^2+repmat(ex_vv.',size(ex_uu)).^2)).*exp(-1j*2*pi/lambda*z_propagation); %픽셀작을땐 이게오래걸림..
% y_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;   x_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;
% complex_sum = gather(ex_map(y_range, x_range));
% 
% new_xx =  ex_uu(x_range)*lambda*z_propagation;
% new_yy =  ex_vv(y_range)*lambda*z_propagation;
% end
% %% Converging propagation
% if z_propagation <= 0
% z_propagation = -z_propagation;
% 
% if strcmp(xymap_before_or_after, 'after')  
% xx = lambda*z_propagation/(xx(2)-xx(1)).^2/2/NN * xx;
% yy = lambda*z_propagation/(yy(2)-yy(1)).^2/2/NN * yy;
% end
% uu = xx/lambda/z_propagation; vv = yy/lambda/z_propagation;
% 
% du = uu(2)-uu(1); dv = vv(2)-vv(1);
% ex_dx = 1/ex_NN/du; ex_dy = 1/ex_NN/dv;
% 
% ex_xx = single(ex_dx*[-ex_NN/2+1:ex_NN/2]);
% ex_yy = single(ex_dy*[-ex_NN/2+1:ex_NN/2]);
% 
% map = input_data.*exp(+1j*2*pi/lambda*z_propagation).*exp(+1j*pi*lambda*z_propagation*(repmat(uu,size(vv.')).^2+repmat(vv.',size(uu)).^2));
% ex_map = padarray(gpuArray(map), [(expansion_factor-1)*NN/2 (expansion_factor-1)*NN/2]); clear map;
% 
%  
% %  t5 = clock  ;
% % ex_map = fftshift(ifft2(ifftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
% ex_map = ifftshift(fft2(fftshift(ex_map))); % 상이 안뒤집히는 이걸로 함
% % disp(['  "fft" calculation time : ' num2str(etime(clock,t5))]);
% ex_map = ex_map.*exp(+1j*pi*(repmat(ex_xx,size(ex_yy.')).^2+repmat(ex_yy.',size(ex_xx)).^2)/lambda/z_propagation);  
% 
%  y_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;   x_range = ex_NN/2-NN/2+1:ex_NN/2+NN/2;
% % figure(67)
% % imagesc(real(ex_map)); axis xy; 
%  complex_sum = gather(ex_map(y_range, x_range));
%  new_xx = ex_xx(x_range);  new_yy = ex_yy(y_range);
%  
% %  px = new_xx(2)-new_xx(1);
% %  py = new_yy(2)-new_yy(1);
%  
% end



end