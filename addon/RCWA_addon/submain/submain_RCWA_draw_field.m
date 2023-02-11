%% define what to draw
switch field_to_draw
    case 'Ex'
        if exist('Ex_final'); field = Ex_final ; 
        else warning(['There is no Ex!!']); end
    case 'Ey'
        if exist('Ey_final'); field = Ey_final ; 
        else warning(['There is no Ey!!']); end      
    case 'Ez'
        if exist('Ez_final'); field = Ez_final ; 
        else warning(['There is no Ez!!']); end      
    case 'Hx'
        if exist('Hx_final'); field = Hx_final ; 
        else warning(['There is no Hx!!']); end
    case 'Hy'
        if exist('Hy_final'); field = Hy_final; 
        else warning(['There is no Hy!!']); end       
    case 'Hz'
        if exist('Hz_final'); field = Hz_final; 
        else warning(['There is no Hz!!']); end           
    case 'Power_x'
        if exist('Power_x'); field = Power_x ; 
        else warning(['There is no Power_x!!']); end        
    case 'Power_y'
        if exist('Power_y'); field = Power_y ; 
        else warning(['There is no Power_y!!']); end        
    case 'Power_z'
        if exist('Power_z'); field = Power_z ; 
        else warning(['There is no Power_z!!']); end        
end

if size(field,4) ~= 1
w_t = reshape(exp(-j*w_set*view_time),[1 1 1 length(w_set)]);    
field = sum(field.*w_t,4);
end

max_value = max(max(abs(field)))+eps;
um = 1e-6;


%%    Real function (Real(Ex) 꼴)
if (Phase_Animation == 0) && strcmp(real_or_abs,'real')
imagesc(row_/um,col_/um,real(field)); axis xy; colormap jet;
axis([row_(1)/um row_(end)/um col_(1)/um col_(end)/um]);colorbar; caxis(1*max_value*[-1 1]);
set(gca,'fontsize',20,'fontname','times'); 
%%   Absolute square (|Ex| 꼴)
elseif strcmp(real_or_abs,'abs')
imagesc(row_/um,col_/um,abs(field)); axis xy; colormap hot;
axis([row_(1)/um row_(end)/um col_(1)/um col_(end)/um]);colorbar; caxis(1*max_value*[0 1]);
set(gca,'fontsize',20,'fontname','times'); 
%%   Absolute square (|Ex|^2 꼴)
elseif strcmp(real_or_abs,'abs_square')
imagesc(row_/um,col_/um,abs(field).^2); axis xy; colormap hot;
axis([row_(1)/um row_(end)/um col_(1)/um col_(end)/um]);colorbar; caxis(1*max_value^2*[0 1]);
set(gca,'fontsize',20,'fontname','times'); 
%%   Phase animation  (Real 만 가능)
else
for phase = 0:2*pi/20:2*pi*Animation_period
imagesc(row_/um,col_/um,real(field*exp(-j*phase))); axis xy; colormap jet;
axis([row_(1)/um row_(end)/um col_(1)/um col_(end)/um]);colorbar; caxis(1*max_value*[-1 1]);
set(gca,'fontsize',20,'fontname','times');
pause(0.01);
end
end