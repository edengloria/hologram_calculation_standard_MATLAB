function Reconstructed_eye = eye_view_calculation(Reconstructed_GPU, viewing_distance, eye_pupil_radius, eye_shift_x, eye_shift_y, eye_length, ispupil, expansion_factor, theta_recon, phi_recon, theta_obs, phi_obs) ; 
global mm cm lambda k0 px py Nx Ny;

% expansion_factor = 2; 

k0 = 2*pi/lambda;
xx = single(px*[-Nx/2+1:Nx/2]);
yy = single(py*[-Ny/2+1:Ny/2]);
% [x y] = meshgrid(xx,yy); 
% 메모리터짐방지 x = repmat(xx,size(yy.'));  y=repmat(yy',size(xx));
kx_obs = k0*sind(theta_obs)*cosd(phi_obs);
ky_obs = k0*sind(theta_obs)*sind(phi_obs);

Reconstructed_far = expanded_transfer_GPU_n(Reconstructed_GPU, expansion_factor, theta_recon, phi_recon,  theta_obs, phi_obs, viewing_distance*cosd(theta_obs) , 1,1) ;


if ispupil == 1
eye_filter = (x-eye_shift_x).^2 + (y-eye_shift_y).^2 <= eye_pupil_radius^2;
Reconstructed_far = Reconstructed_far.*eye_filter;
end


eye_f = (eye_length.*viewing_distance)/(eye_length+viewing_distance);
Reconstructed_far = Reconstructed_far.*exp(j*k0*((repmat(xx,size(yy.'))-eye_shift_x).^2 + (repmat(yy',size(xx))-eye_shift_y).^2)/2/eye_f);
if theta_obs ~= 0
Reconstructed_far = Reconstructed_far.*exp(j*(kx_obs*repmat(xx,size(yy.'))+ky_obs*repmat(yy',size(xx))));
end
% Reconstructed_eye = expanded_transfer_GPU_n(Reconstructed_far , expansion_factor, 0, 0, 0, 0, eye_length*cosd(theta_obs) , 1,1) ;
Reconstructed_eye = expanded_transfer_GPU_n(Reconstructed_far , expansion_factor, 0, 0, 0, 0, eye_length*cosd(theta_obs), 1,1) ;


end
