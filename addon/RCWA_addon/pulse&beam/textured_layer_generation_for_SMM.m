function [R_toeplitz T_toeplitz] = textured_layer_generation_for_SMM(k0,Kx,Ky)


Kx_ = reshape(Kx,[Ny Nx]);
Ky_ = reshape(Ky,[Ny Nx]);
Krho = sqrt(Kx_.^2+Ky_.^2);
angle = asind(Krho/k0);
a = 30^2;
T = exp(-real(angle).^2/2/a).*(real(angle)<90);

T_sum = 0.9;

T = T_sum*T/sum(sum(T));
R = (1-T_sum)*T/sum(sum(T));
T_toeplitz        = folded_toeplitz_2D(T);
R_toeplitz        = folded_toeplitz_2D(R);
%% surface current % -Hy Hx
% phase =0;
% 
% image_index = 0;
% fps = 10 ;
% 
% for xcnt = 1:5:sqrt(size(T_toeplitz,1))
%     for ycnt = 1:5:sqrt(size(T_toeplitz,1))
%         cnt = ycnt + (xcnt-1)*sqrt(size(T_toeplitz,1));
% [Kx_view  Ky_view]                   = get_Kx_Ky_col(NBx,NBy,gambda_x,gambda_y,kx,ky);
% Kx_view_ = reshape(Kx_view,[NBy NBx]);
% Ky_view_ = reshape(Ky_view,[NBy NBx]);
% T_temp = reshape(T_toeplitz(cnt,:),[NBy NBx]);
% 
% 
% figure(1); set(gca,'fontsize',20); set(gca,'fontname','times new roman');
% mesh(real(Kx_view_(Mx,:))/k0,real(Ky_view_(:,My))/k0,real(T_temp));set(gca,'fontname','times new roman');
%     xlabel('kx / k0');set(gca,'fontname','times new roman');
%     ylabel('ky / k0'); axis([-2 2 -2 2 0 max(max(T))/T_sum]);
% 
% image_index=image_index+1;
% figname = ['test_shot_' num2str(image_index, '%03d')];
% gifname = ['test_shot_gif'];
% 
% print('-djpeg',[figname '.jpg']);
% 
%     if image_index == 1,
%         IMAGE = getframe(gcf);
%         IMAGE = frame2im(IMAGE);
%         [X, map] = rgb2ind(IMAGE, 256);
%         imwrite(X, map, gifname, 'gif', 'WriteMode', 'overwrite', 'DelayTime', 1/fps, 'LoopCount', Inf);
%     else
%         IMAGE = getframe(gcf);
%         IMAGE = frame2im(IMAGE);
%         [X, map] = rgb2ind(IMAGE, 256);
%         imwrite(X, map, gifname, 'gif', 'WriteMode', 'append', 'DelayTime', 1/fps);
%     end    
%     
%     end
% end    
%     figure(2); set(gca,'fontsize',20); set(gca,'fontname','times new roman');
% mesh(real(Kx_(Mx,:))/k0,real(Ky_(:,My))/k0,real(R));set(gca,'fontname','times new roman');
%     xlabel('kx / k0');set(gca,'fontname','times new roman');
%     ylabel('ky / k0'); axis([-2 2 -2 2 0 max(max(T))/T_sum]);