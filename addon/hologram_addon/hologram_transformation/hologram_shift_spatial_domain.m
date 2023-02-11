function CGH_pattern_out = hologram_shift_spatial_domain(CGH_pattern,shift_xyz);

global lambda px py Nx Ny Ideal_angle_limit;
ex_Nx = Nx*2; ex_Ny = Ny*2; % num of pixel
ex_size_x = ex_Nx*px;
ex_size_y = ex_Nx*py; % hologram size
ex_dfx = 1/ex_size_x; ex_dfy = 1/ex_size_y;
u = single(ex_dfx*[-ex_Nx/2+1:ex_Nx/2]);
v = single(ex_dfy*[-ex_Ny/2+1:ex_Ny/2]);

[ex_uu, ex_vv] = meshgrid(u,v);

CGH_pattern = padarray(CGH_pattern,[Ny/2 Nx/2]);
CGH_pattern= ifftshift(fft2(fftshift(CGH_pattern))); % ���� -> �������ļ� ������
CGH_pattern = hologram_shift_FFT_domain(CGH_pattern,shift_xyz,ex_uu,ex_vv); % �������ļ� �����ο��� shift
CGH_pattern= fftshift(ifft2(ifftshift(CGH_pattern))); % �������ļ� -> ���� ������

 y_range = ex_Ny/2-Ny/2+1:ex_Ny/2+Ny/2;   x_range = ex_Nx/2-Nx/2+1:ex_Nx/2+Nx/2;
 
CGH_pattern_out = CGH_pattern(y_range,x_range);
end