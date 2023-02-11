function Reconstructed_eye = fast_eye_view_calculation(Reconstructed_GPU_FFT, view_NN, viewing_distance, eye_length, theta_obs, phi_obs,image_center) ; 
%% 2020/07/30 작성: 선택된 각도성분만을 추출하여 매우 빠른 속도로 eye_view 렌더링 계산한다
% 구 버전 대비 매우 빠르며, 20도 이상의 아주 큰 사입사 뷰에서도 잘 동작한다. 입력 필드는 FFT하여 입력해야 함.
% 단, 잔상이 생길 수 있는데, 정확한 원인 파악중이며, view_NN값을 적당히 조절하다보면 잔상이 사라지는 경우 존재함 <- 해결
%% 2021/02/16 에러 수정: 위치 2의 인덱스가 유효하지 않습니다. 배열 인덱스는 양의 정수이거나 논리값이어야 합니다.
% 관측각도의 범위가 최대 회절각을 초과할 때 발생하는 에러이다. 이 경우에는 경고를 출력하고 아무것도 계산하지 않도록 변경

global Part3 lambda k0 Nx Ny px py;

  obs_thx = sind(theta_obs)*cosd(phi_obs);    obs_thy = sind(theta_obs)*sind(phi_obs);
  dfx = 1/Nx/px; dfy = 1/Ny/py;
  ex_uu = single(dfx*[-Nx/2+1:Nx/2]); % sin_thx= 2*pi*uu/k0; 
  ex_vv = single(dfy*[-Ny/2+1:Ny/2]);
  sin_thx= 2*pi*ex_uu/k0;     sin_thy= 2*pi*ex_vv/k0; 
  
%% 각도성분의 중심점을 찾는다
  [dummy thx_center] = min(abs(sin_thx - obs_thx));    [dummy thy_center] = min(abs(sin_thy - obs_thy));
%   view_NN = 2*view_NN; %expansion 효과, 최종 출력 데이타 사이즈를 넣어준 view_NN으로 맞춰준다.

if ((thx_center-view_NN/2+1)<1)|((thx_center+view_NN/2)>Nx);
warning('x 방향으로 관측 한계 범위를 벗어나므로 영행렬을 출력합니다');
Reconstructed_eye = zeros([view_NN view_NN]); return;
end

if ((thy_center-view_NN/2+1)<1)|((thy_center+view_NN/2)>Ny);
warning('y 방향으로 관측 한계 범위를 벗어나므로 영행렬을 출력합니다');
Reconstructed_eye = zeros([view_NN view_NN]); return;
end

%% 중심점을 기준으로 FFT데이타 일부 추출  
if strcmp(Reconstructed_GPU_FFT,'not used')
filename_view = 'Reconstructed_GPU_FFT';
ex_map = (bin_read(filename_view,[Ny Nx],[view_NN view_NN],[thy_center-view_NN/2+1 thx_center-view_NN/2+1])); 
else
ex_map = gpuArray(Reconstructed_GPU_FFT(thy_center-view_NN/2+1:1:thy_center+view_NN/2,thx_center-view_NN/2+1:1:thx_center+view_NN/2));
end

%% test code
% figure(121)
% imagesc(abs(fftshift(ifft2(ifftshift(ex_map)))));

%%
 viewing_distance_sum = viewing_distance + image_center*(1-Part3(1)) ; 
  
  
  view_px = 1/dfx/view_NN; % 추출로 인해 확장된 픽셀 크기
  new_uv = single(dfx*[-view_NN/2+1:view_NN/2]); 
  [new_uu new_vv] = meshgrid(new_uv,new_uv);
  
if asind(lambda/view_px/2) >= atand(view_NN*view_px/abs( viewing_distance_sum))
    ASM_filter = 1;
    theta_limit = atand(view_NN*view_px/abs( viewing_distance_sum));
else
    ASM_filter = 0;
end


%  figure(120)
%  imagesc(abs(Reconstructed_GPU_FFT));
% 
%  figure(121)
%  imagesc(abs(ex_map));


if ASM_filter == 1
 uv_filter = (abs(new_uu) < sind(theta_limit)/lambda) & (abs(new_vv) < sind(theta_limit)/lambda);
 ex_map = ex_map.*uv_filter;
end 
 
 n_material = 1; % 공기층 전파 가정
 ex_ww = (real(sqrt(n_material.^2./lambda^2-(new_uu).^2 - (new_vv).^2)));
%  ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-(new_uu).^2 - (new_vv).^2)));
 
 ex_map = ex_map.*exp(- j * 2 * pi * ex_ww *  viewing_distance_sum);
 ex_map = fftshift(ifft2(ifftshift((ex_map))));
 
%   figure(122)
%  imagesc(abs(ex_map));
 
 ex_map = padarray(ex_map, [view_NN/2 view_NN/2]);
 
 view_xx = single(view_px*[-view_NN+1:view_NN]); 
 view_yy = view_xx; [view_x view_y] = meshgrid(view_xx,view_yy);

 new_uv = single(dfx/2*[-view_NN+1:view_NN]); 
 [new_uu new_vv] = meshgrid(new_uv,new_uv); 
 
 eye_f = (eye_length.*viewing_distance)/(eye_length+viewing_distance); 
 filter = pi/view_px*0.95;
 filter_size_rho = filter*eye_f/k0;
 ex_map =  ex_map.*exp(j*k0*(view_x.^2 + view_y.^2)/2/eye_f).*(sqrt(view_x.^2 + view_y.^2)<=filter_size_rho);
%  figure(321)
%  imagesc(real(ex_map));
ex_map = ifftshift(fft2(fftshift((ex_map))));  

if ASM_filter == 1
uv_filter = (abs(new_uu) < sind(theta_limit)/lambda) & ( abs(new_vv) < sind(theta_limit)/lambda);
ex_map = ex_map.*uv_filter;
end 



% ex_ww = gpuArray(real(sqrt(n_material.^2./lambda^2-(new_uu).^2 - (new_vv).^2)));
ex_ww = (real(sqrt(n_material.^2./lambda^2-(new_uu).^2 - (new_vv).^2)));
ex_map = ex_map.*exp(- j * 2 * pi * ex_ww * eye_length);

ex_map = fftshift(ifft2(ifftshift((ex_map))));

y_range = view_NN/2+1:3*view_NN/2;   x_range = view_NN/2+1:3*view_NN/2;
% Reconstructed_eye = (ex_map(y_range, x_range));
Reconstructed_eye = gather(ex_map(y_range, x_range));
end
