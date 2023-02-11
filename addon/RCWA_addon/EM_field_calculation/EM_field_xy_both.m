function [Ex Ey Ez Hx Hy Hz] = field3D_on_xy_E_H_general(W,V,Q,invE,Cgp,Cgn,Kx,Ky,k0,x,y,z_1,acc_thick,width_type,dc_profile)
global L;
% USAGE
% xx = linspace(-gambda_x/2,gambda_x/2,  200);
% zz = linspace(0,acc_thick(layer_ouput),200);
% [Ex Ez Hy intensity]   = field2D_on_xz_middle(W,Q,X,V,Cgp,Cgn,Kx,k0,xx,  zz,acc_thick,layer_input,layer_ouput);
% figure(10);
%                imagesc(abs(Ex));colormap(hot);colorbar
%                                                       

% NOTE
% 2007.07.31    Hy, Ez add. Ep(:,:,layer_num+2) parameter added to calculate z-component of E
% 2007.04.26    considering start point 0... modify
%                   z_start = 0;                                % if layer_input.. then.. start is zero
%                   z_start = z(1);                                % if layer_input.. then.. start is zero
% 2007.04.21    considering start point 0
% 2007.04.18    important difference between xz and xy...
%                   xz
%                       W is 3 dim array
%                   xy
%                       W is 2 dim array
% 2007.04.18    modified                
%               how
%                   before  (W,Q,X,V,Cgp,Cgn,Kx,Ky,acc_thick,k0,x,y_1,z,          layer_start,layer_end)
%                   after   (W,Q,X,V,Cgp,Cgn,Kx,Ky,         ,k0,x,y_1,z,acc_thick,layer_start,layer_end)
%               why
%                   similarity in parameter order with xy_ series
% 2007.04.13    You can use the... yz_middle function, by just switch... all x and y in input
% L           = size(W,1)/2;        % L = (2Mx+1)(2My+1),  W is (2L by 2L) matrix

%%

% modeNum     = 1*L;              % x component
xNum        = length(x);        % length of x region
yNum        = length(y);        % length of x region
layNum      = length(acc_thick);
% y           = y_1*ones(1,xNum); % fixed y

[x_ Kx_]    = meshgrid(x,Kx);                               % common phase vector
% [y_ Ky_]    = meshgrid(y,Ky);
% exp_jk      = exp(  j*  (x_.*Kx_ + y_.*Ky_)  );             % (K1-2)    phase term
exp_jkx     = exp(  j*  (x_.*Kx_));
clear x_ Kx_;

% zNum        = length(z);        % length of z region


Ex          = zeros(yNum,xNum); % output region
Ey          = zeros(yNum,xNum);
Ez          = zeros(yNum,xNum);
Hx          = zeros(yNum,xNum);
Hy          = zeros(yNum,xNum);
Hz          = zeros(yNum,xNum);
layIdx      = 1;                                    % layer index
if width_type(layIdx) ==0 && dc_profile(layIdx) ~= 0
% W_          = eye(size(W(:,:,1)));
% [KI Kz] = get_KI_from_Kx_Ky_n0(Kx,Ky,real(sqrt(dc_profile(layIdx))),k0,L);
% V_          = KI/k0/j;
[W_, V_, Kz] =get_WV_for_dc_layer_Kx_Ky(Kx,Ky,sqrt(dc_profile(layIdx)),k0);
Q_          = j*[Kz;Kz];
iE          = (1/dc_profile(layIdx))*eye(L,L);
else
W_          = W   (:,:,width_type(layIdx));
V_          = V   (:,:,width_type(layIdx));
Q_          = Q   (:,:,width_type(layIdx));
iE          = invE(:,:,width_type(layIdx));
end        
Q_1         = zeros(2*L,1);
for q=1:2*L
    if Cgp(q,1,1) ~= 0
        mode_sel = q;
        Q_1(q) = Q_(q,1,1); % selected mode 만 켜겠다는 의지.
        break
    end
end

% for zIdx = 1: zNum
    
    zz      = z_1;                              % zz is scalar value representing the position
    
    while zz > acc_thick(layIdx) && layIdx < layNum   % seek layIdx in which is zz
        layIdx = layIdx + 1;

%         disp(['changing from layer ' num2str(layIdx-1) ' to layer ' num2str(layIdx) '  point : ' num2str(zz*1e9) ' nm, idx : ' num2str(zIdx)]);
    end
    
        if width_type(layIdx) ==0 && dc_profile(layIdx) ~= 0
%         W_          = eye(size(W(:,:,1)));
%         [KI Kz] = get_KI_from_Kx_Ky_n0(Kx,Ky,real(sqrt(dc_profile(layIdx))),k0,L);
%         V_          = KI/k0/j;
        [W_, V_, Kz] =get_WV_for_dc_layer_Kx_Ky(Kx,Ky,sqrt(dc_profile(layIdx)),k0);
        Q_          = j*[Kz;Kz];
        iE          = (1/dc_profile(layIdx))*eye(L,L);
        else
        W_          = W   (:,:,width_type(layIdx));
        V_          = V   (:,:,width_type(layIdx));
        Q_          = Q   (:,:,width_type(layIdx));
        iE          = invE(:,:,width_type(layIdx));
        end

    if     layIdx == 1                                  % seek up and bottom position of this layer
        z_start = acc_thick(1       ); % artificial
        z_enddd = acc_thick(layIdx  );
%         Xps     = exp( (zz-z_start) * Q_ );              % size of ( L by 1)
        Xns     = exp(-(zz-z_enddd) * Q_ );
        Xps     = exp( (zz-z_start) * Q_1 );              % size of ( L by 1)
%         Xns     = exp(-(zz-z_enddd) * Q_1 );
    elseif layIdx == layNum
        z_start = acc_thick(layIdx-1);
%         z_enddd = acc_thick(layIdx-1); % artificial
        Xps     = exp( (zz-z_start) * Q_ );              % size of ( L by 1)
        Xns     = ones(2*L,1); % 안 쓰인다.
    else
        z_start = acc_thick(layIdx-1);
        z_enddd = acc_thick(layIdx  );
        Xps     = exp( (zz-z_start) * Q_ );              % size of ( L by 1)
        Xns     = exp(-(zz-z_enddd) * Q_ );
    end

for yIdx = 1: yNum   
% %     Sx      = repmat(W_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx)),1,xNum);
% %     Uy      = repmat(V_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx)),1,xNum);
%     Sx_     = W_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx));
%     Uy_     = V_ * (Xps.*Cgp(:,1,layIdx) - Xns.*Cgn(:,1,layIdx));
%      Sz_     = -j*iE * (Kx .* Uy_);
% %     Sz_     = iE * (Kx .* Sx_);
%     Sx      = repmat(Sx_,1,xNum);
%     Ex_     = sum(Sx .* exp_jk);
% %     clear Sx
%     
%     Uy      = repmat(Uy_,1,xNum);
%     Hy_     = j*sum(Uy .* exp_jk);    
% %     clear Uy
%     
%     Sz      = repmat(Sz_,1,xNum);
%     Ez_     = sum(Sz .* exp_jk);    
% %     clear Sz
%     
% 
% 
% 
%     Ex(zIdx,:) = Ex_;
%     Hy(zIdx,:) = Hy_;
%     Ez(zIdx,:) = Ez_/k0;
% end
%     Sx      = repmat(W_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx)),1,xNum);
%     Uy      = repmat(V_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx)),1,xNum);
    Sxy_     = W_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx));
    Uxy_     = V_ * (Xps.*Cgp(:,1,layIdx) - Xns.*Cgn(:,1,layIdx));
    
    Sx_     = Sxy_(1    :L  );
    Sy_     = Sxy_(L+1:2*L);
    
    Ux_     = Uxy_(1    :L  );
    Uy_     = Uxy_(L+1:2*L);
    
    Sz_     = -j*iE * (Kx .* Uy_- Ky .* Ux_)/k0;
    Uz_     = -j*     (Kx .* Sy_- Ky .* Sx_)/k0;
    
%     Sz_     = iE * (Kx .* Sx_);
    Sx      = repmat(Sx_,1,xNum);
    Sy      = repmat(Sy_,1,xNum);
    Sz      = repmat(Sz_,1,xNum);
    Ux      = repmat(Ux_,1,xNum);
    Uy      = repmat(Uy_,1,xNum);
    Uz      = repmat(Uz_,1,xNum);

    exp_jky     = repmat(exp(j*y(yIdx)*Ky),1,xNum);
    
    Ex_     = sum(Sx .* exp_jkx.*exp_jky);
    Ey_     = sum(Sy .* exp_jkx.*exp_jky);
    Ez_     = sum(Sz .* exp_jkx.*exp_jky);
    Hx_     = j*sum(Ux .* exp_jkx.*exp_jky);
    Hy_     = j*sum(Uy .* exp_jkx.*exp_jky);
    Hz_     = j*sum(Uz .* exp_jkx.*exp_jky);
    
    
    Ex(yIdx,:) = Ex_;
    Ey(yIdx,:) = Ey_;
    Ez(yIdx,:) = Ez_;
    Hx(yIdx,:) = Hx_;    
    Hy(yIdx,:) = Hy_;
    Hz(yIdx,:) = Hz_;    
end
return