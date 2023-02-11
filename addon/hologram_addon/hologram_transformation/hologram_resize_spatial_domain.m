function CGH_pattern_out =  hologram_resize_spatial_domain(CGH_pattern,hologram_ex_factor,image_center);
global Nx Ny px py;

if hologram_ex_factor == 1
     CGH_pattern_out =  CGH_pattern; % do nothing
elseif hologram_ex_factor > 1 % Ȧ�α׷� Ȯ��

dfx = 1/px/Nx; dfy = 1/py/Ny;        % ���ļ� ������ ���� ����
uu = single(dfx*[-Nx/2+1:Nx/2]);
vv = single(dfy*[-Ny/2+1:Ny/2]);
[u, v] = meshgrid(uu,vv);

y_pad = ceil((hologram_ex_factor-1)*Ny/2); x_pad = ceil((hologram_ex_factor-1)*Nx/2);

CGH_pattern= ifftshift(fft2(fftshift(CGH_pattern))); % ���� -> �������ļ� ������
CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 -image_center*(1-1/hologram_ex_factor^2)],u,v); % �����Ÿ� ���������� �մ��
CGH_pattern = padarray(CGH_pattern, [y_pad x_pad]); % ���ļ� ������ ���� �е�, �����ŭ Ŀ���� 
CGH_pattern= fftshift(ifft2(ifftshift(CGH_pattern))); % ����ȯ�ϸ� Ŀ�� Ȧ�α׷��� ������

y_range = [y_pad+1:1:y_pad+Ny]; x_range = [x_pad+1:1:x_pad+Nx];
CGH_pattern_out = CGH_pattern(y_range,x_range); % ���� �ػ󵵷� cropping

elseif hologram_ex_factor < 1 % Ȧ�α׷� ���

dfx = 1/px/Nx; dfy = 1/py/Ny;        % �ȼ� ũ�⸦ �ӽ÷� �����ŭ �ٿ��� u v �� ����
uu = single(dfx*[-Nx/2+1:Nx/2]);
vv = single(dfy*[-Ny/2+1:Ny/2]);
[u, v] = meshgrid(uu,vv);        
    
CGH_pattern= ifftshift(fft2(fftshift(CGH_pattern))); % ���� -> �������ļ� ������

CGH_pattern = imresize(CGH_pattern,[2*ceil(Ny/hologram_ex_factor/2)  2*ceil(Nx/hologram_ex_factor/2)]); % ¦���� �����Ѵ�.
y_pad = (size(CGH_pattern,1)-Ny)/2;    x_pad = (size(CGH_pattern,2)-Nx)/2;    

y_range = [y_pad+1:1:y_pad+Ny]; x_range = [x_pad+1:1:x_pad+Nx];
CGH_pattern = CGH_pattern(y_range,x_range); % ���� �ػ󵵷� cropping
        
type = 1; % 1:���ܹ���   2:�ܻ����Ź���
if type == 2
%% ��������
 CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 image_center*(1-hologram_ex_factor^2)],u,v); % �����Ÿ� �������� �δ�
 CGH_pattern_out = fftshift(ifft2(ifftshift(CGH_pattern))); 
else
%% �ֺ� �ܻ���� �����ִ� ����
CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 image_center*(-hologram_ex_factor^2)],u,v); % �����Ÿ� ������ �д� ��������
CGH_pattern = fftshift(ifft2(ifftshift(CGH_pattern))); 
y_small = ceil(Ny*hologram_ex_factor/2); x_small = ceil(Nx*hologram_ex_factor/2);
CGH_pattern = padarray(CGH_pattern(Ny/2+1-y_small:Ny/2+y_small, Nx/2+1-x_small:Nx/2+x_small),[Ny/2-y_small Nx/2-x_small]);
CGH_pattern = ifftshift(fft2(fftshift(CGH_pattern)));
CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,[0 0 image_center],u,v); % �����Ÿ� ������ �д� �������� 
CGH_pattern_out = fftshift(ifft2(ifftshift(CGH_pattern))); 
end

% imagesc(abs(CGH_pattern_out))

% ����ȯ�ϸ� ��ҵ� Ȧ�α׷��� ������



end
end