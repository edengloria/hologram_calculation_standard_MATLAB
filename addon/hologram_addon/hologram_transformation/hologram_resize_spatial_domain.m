function CGH_pattern_out =  hologram_resize_spatial_domain(CGH_pattern,hologram_ex_factor,image_center);
global Nx Ny px py;

if hologram_ex_factor == 1
     CGH_pattern_out =  CGH_pattern; % do nothing
elseif hologram_ex_factor > 1 % 홀로그램 확대

dfx = 1/px/Nx; dfy = 1/py/Ny;        % 주파수 도메인 벡터 생성
uu = single(dfx*[-Nx/2+1:Nx/2]);
vv = single(dfy*[-Ny/2+1:Ny/2]);
[u, v] = meshgrid(uu,vv);

y_pad = ceil((hologram_ex_factor-1)*Ny/2); x_pad = ceil((hologram_ex_factor-1)*Nx/2);

CGH_pattern= ifftshift(fft2(fftshift(CGH_pattern))); % 공간 -> 공간주파수 도메인
CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 -image_center*(1-1/hologram_ex_factor^2)],u,v); % 초점거리 선보정으로 앞당김
CGH_pattern = padarray(CGH_pattern, [y_pad x_pad]); % 주파수 도메인 제로 패드, 배수만큼 커진다 
CGH_pattern= fftshift(ifft2(ifftshift(CGH_pattern))); % 역변환하면 커진 홀로그램이 형성됨

y_range = [y_pad+1:1:y_pad+Ny]; x_range = [x_pad+1:1:x_pad+Nx];
CGH_pattern_out = CGH_pattern(y_range,x_range); % 동일 해상도로 cropping

elseif hologram_ex_factor < 1 % 홀로그램 축소

dfx = 1/px/Nx; dfy = 1/py/Ny;        % 픽셀 크기를 임시로 배수만큼 줄여서 u v 맵 형성
uu = single(dfx*[-Nx/2+1:Nx/2]);
vv = single(dfy*[-Ny/2+1:Ny/2]);
[u, v] = meshgrid(uu,vv);        
    
CGH_pattern= ifftshift(fft2(fftshift(CGH_pattern))); % 공간 -> 공간주파수 도메인

CGH_pattern = imresize(CGH_pattern,[2*ceil(Ny/hologram_ex_factor/2)  2*ceil(Nx/hologram_ex_factor/2)]); % 짝수로 가야한다.
y_pad = (size(CGH_pattern,1)-Ny)/2;    x_pad = (size(CGH_pattern,2)-Nx)/2;    

y_range = [y_pad+1:1:y_pad+Ny]; x_range = [x_pad+1:1:x_pad+Nx];
CGH_pattern = CGH_pattern(y_range,x_range); % 동일 해상도로 cropping
        
type = 1; % 1:간단버전   2:잔상제거버전
if type == 2
%% 원래버전
 CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 image_center*(1-hologram_ex_factor^2)],u,v); % 초점거리 보정으로 민다
 CGH_pattern_out = fftshift(ifft2(ifftshift(CGH_pattern))); 
else
%% 주변 잔상까지 지워주는 버전
CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 image_center*(-hologram_ex_factor^2)],u,v); % 초점거리 원점에 둔다 보정으로
CGH_pattern = fftshift(ifft2(ifftshift(CGH_pattern))); 
y_small = ceil(Ny*hologram_ex_factor/2); x_small = ceil(Nx*hologram_ex_factor/2);
CGH_pattern = padarray(CGH_pattern(Ny/2+1-y_small:Ny/2+y_small, Nx/2+1-x_small:Nx/2+x_small),[Ny/2-y_small Nx/2-x_small]);
CGH_pattern = ifftshift(fft2(fftshift(CGH_pattern)));
CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 image_center],u,v); % 초점거리 원점에 둔다 보정으로 
CGH_pattern_out = fftshift(ifft2(ifftshift(CGH_pattern))); 
end

% imagesc(abs(CGH_pattern_out))

% 역변환하면 축소된 홀로그램이 형성됨



end
end