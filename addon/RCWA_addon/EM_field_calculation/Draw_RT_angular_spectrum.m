function Draw_RT_angular_spectrum(R_diff, T_diff, kx ,ky);
global Tx Ty TETM Dimension k0;

 Lx = size(R_diff,1);

 theta_x_set = asind((kx + 2*pi/Tx *[-(Lx-1)/2 : 1 :(Lx-1)/2])/k0);
 [dummy, range_x] = find(abs(imag(theta_x_set)) < 0.0001) ;

 if strcmp(Dimension, '3D')
 Ly = size(R_diff,1);
 theta_y_set = asind((ky + 2*pi/Ty *[-(Ly-1)/2 : 1 :(Ly-1)/2])/k0);
 [dummy, range_y] = find(abs(imag(theta_y_set)) < 0.0001) ; 
 end
% R_diff = zeros(length(range),1);
% T_diff = zeros(length(range),1);


if strcmp(Dimension, '2D') 

    if strcmp(TETM, 'TM') || strcmp(TETM, 'TE')
    figure(111)
    plot(theta_x_set(range_x), R_diff(range_x)); title(['Reflected Angular Spectrum']); 
    axis([-90 90 0 1]);
    figure(112)
    plot(theta_x_set(range_x), T_diff(range_x)); title(['Transmitted Angular Spectrum']); 
    axis([-90 90 0 max(T_diff)]);
    elseif strcmp(TETM, 'both')
    figure(111)
    plot(R_diff(range_x,1) + R_diff(range_x,2)); title(['Reflected Angular Spectrum']);
    figure(112)
    plot(T_diff(range_x,1) + T_diff(range_x,2)); title(['Transmitted Angular Spectrum']);
    end
    
elseif strcmp(Dimension, '3D') 
figure(111)
imagesc(theta_y_set(range_y), theta_x_set(range_x), R_diff(range_y,range_x,1) + R_diff(range_y,range_x,2)); title(['Reflected Angular Spectrum']); colorbar; colormap gray;
figure(112)
imagesc(theta_y_set(range_y), theta_x_set(range_x), T_diff(range_y,range_x,1) + T_diff(range_y,range_x,2)); title(['Transmitted Angular Spectrum']); colorbar; colormap gray;
end

end