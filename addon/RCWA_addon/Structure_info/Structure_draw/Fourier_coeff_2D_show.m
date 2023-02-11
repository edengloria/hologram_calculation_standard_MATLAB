function Fourier_coeff_2D_show(Epsl_in,pic,dimension)
global Nx Ny Tx Ty;

if strcmp(dimension,'\mum');  dim_value = 1e-6;
elseif  strcmp(dimension,'nm'); dim_value = 1e-9;
end

Lx = Tx;
Ly = Ty;
dx = Lx / Nx;
dy = Ly / Ny;

Epsl = ifftshift(Epsl_in);
Epsl = (Lx*Ly) / (dx*dy) * ifft2(Epsl);
Epsl = ifftshift(Epsl);


x_view = [-Lx/2+dx/2:dx:+Lx/2-dx/2];
y_view = [-Ly/2+dy/2:dy:+Ly/2-dy/2];

figure(pic);
title('toeplitz matrix');
% subplot(2,1,1);
% imagesc(x_view,y_view,abs(Epsl));
% xlabel('x');ylabel('y');
% subplot(2,1,2);
% mesh(abs(Epsl));
% xlabel('x');ylabel('y');
% subplot(1,2,1);
imagesc(x_view/dim_value,y_view/dim_value,abs(Epsl).');
% xResol=160;
% yResol=160;
% hold on;rectangle('Position',[xResol/8,yResol/2,xResol*6/8,yResol*3/8],'LineStyle','--','EdgeColor','white');
xlabel(['x (', dimension, ')']); ylabel(['y (', dimension, ')']);  axis xy; colorbar; 
set(gca,'fontsize',20,'fontname','times'); 

% subplot(1,2,2);
% if size(Epsl,2) == 1
%     Epsl = repmat(Epsl,1,2);
% end;
% mesh(abs(Epsl));
% xlabel('y');ylabel('x');


% figure(pic+1);
% mesh(abs(Epsl));

end
