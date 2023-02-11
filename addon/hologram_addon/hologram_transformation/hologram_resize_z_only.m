function CGH_pattern_out =  hologram_resize_z_only(CGH_pattern,hologram_z_ex_factor,image_center);
%% 실패.. 파장 변환시 응용 가능할듯? %%
%%

global Nx Ny px py lambda;

dfx = 1/px/Nx; dfy = 1/py/Ny;        % 주파수 도메인 벡터 생성
uu = single(dfx*[-Nx/2+1:Nx/2]);
vv = single(dfy*[-Ny/2+1:Ny/2]);
[u, v] = meshgrid(uu,vv);


if hologram_z_ex_factor == 1
     CGH_pattern_out =  CGH_pattern; % do nothing
else 
    
CGH_pattern= ifftshift(fft2(fftshift(CGH_pattern))); % 공간 -> 공간주파수 도메인

% z_factor = tan(theta1)/tan(theta2) = n*sqrt(1-sin(theta1)^2/n^2)/sqrt(1-sin(theta1)^2) ~= n;paraxial approximation
n = hologram_z_ex_factor;
w2 = sqrt(n^2/lambda^2-(u).^2 - (v).^2);
w  = sqrt(1/lambda^2-(u).^2 - (v).^2);
% CGH_pattern = CGH_pattern.*exp(-j * 2 * pi * w2 * image_center*n).*exp(-j * 2 * pi * w * (-image_center));
% CGH_pattern = CGH_pattern.*exp(-j * 2 * pi * w * image_center).*exp(-j * 2 * pi * w2 * (-image_center));

CGH_pattern1 = CGH_pattern.*exp(-j * 2 * pi * w2 * image_center*n);
CGH_pattern2 = CGH_pattern.*exp(-j * 2 * pi * w * image_center);

% .*exp(-j * 2 * pi * w * (-image_center)); %되돌아올때 image_center만큼만
CGH_pattern_out= fftshift(ifft2(ifftshift(CGH_pattern1))); 
CGH_pattern_out2= fftshift(ifft2(ifftshift(CGH_pattern2))); 
figure(111)
imagesc(abs(CGH_pattern_out));
figure(112)
imagesc(abs(CGH_pattern_out2));

CGH_pattern3= ifftshift(ifft2(fftshift(abs(CGH_pattern_out)))); 
figure(113)
imagesc(abs(CGH_pattern3));
end

end