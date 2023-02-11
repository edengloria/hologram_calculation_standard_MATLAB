%% eye_view_calculation 구버전 
 eye_pupil_radius = 5*mm; 
 eye_shift_x = 0*mm;  eye_shift_y = 0*mm;
 ispupil = 0; %pupil 있으면 1, 없으면 0
 Reconstructed_eye = eye_view_calculation(Reconstructed_GPU, viewing_distance, eye_pupil_radius, eye_shift_x, eye_shift_y, eye_length, ispupil, expansion_factor, 0, 0, theta_obs(1), phi_obs(1)) ;
%% 그림 그리기
figure(4000); % 결과
imagesc(xx/mm,yy/mm,flipud(fliplr(abs(Reconstructed_eye).^2))); colormap hot;
caxis([0 1]); 
axis equal;
%axis xy;
axis([xx(1) xx(end) yy(1) yy(end)]/mm);  % 보는 범위제한
%%