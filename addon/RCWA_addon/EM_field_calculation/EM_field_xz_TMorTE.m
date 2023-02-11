function [Ex_Hx, Hy_Ey, Ez_Hz] = EM_field_xz_TMorTE(W,V,Q,invE,Cgp,Cgn,Kx,k0,x,z,acc_thick,width_type,dc_profile)
global TETM L;  

xNum        = length(x);        % length of x region
layNum      = length(acc_thick);

[x_ Kx_]    = meshgrid(x,Kx);                               % common phase vector
exp_jk      = exp(  j*  (x_.*Kx_ ) );       

clear x_ Kx_;

zNum        = length(z);        % length of z region

Ex_Hx         = zeros(zNum,xNum); % output region
Hy_Ey          = zeros(zNum,xNum);
Ez_Hz          = zeros(zNum,xNum);

layIdx      = 1;                                    % layer index
%% 시작층 WVQE 정의
if width_type(layIdx) ==0
% W_          = eye(L,L);
% [KI Kz]     = get_KI_from_Kx_n0(Kx,(sqrt(dc_profile(layIdx))),k0);
% V_          = KI/k0/j;
[W_, V_, Kz] = get_WV_for_dc_layer_Kx(Kx, sqrt(dc_profile(layIdx)),k0);
Q_          = j*Kz;
iE          = (1/dc_profile(layIdx))*eye(L,L);
else
W_          = W   (:,:,width_type(layIdx));
V_          = V   (:,:,width_type(layIdx));
Q_          = Q   (:,:,width_type(layIdx));
iE          = invE(:,:,width_type(layIdx));
end
%% selected mode 만 켜겠다는 의지.
Q_1         = zeros(L,1);
for q=1:L
    if Cgp(q,1,1) ~= 0
        mode_sel = q;
        Q_1(q) = Q_(q,1,1); % 
%         break
    end
end

%% z를 증가시켜가며 그린다
for zIdx = 1: zNum
    
    zz      = z(zIdx);                              % zz is scalar value representing the position
    
    while zz > acc_thick(layIdx) && layIdx < layNum   % seek layIdx in which is zz
        layIdx = layIdx + 1;
        if width_type(layIdx) ==0 && dc_profile(layIdx) ~= 0
%         W_          = eye(L,L);
%         [KI Kz]     = get_KI_from_Kx_n0(Kx,(sqrt(dc_profile(layIdx))),k0);
%         V_          = KI/k0/j;
%         
        [W_, V_, Kz] = get_WV_for_dc_layer_Kx(Kx, sqrt(dc_profile(layIdx)),k0);
        Q_          = j*[Kz];
        iE          = (1/dc_profile(layIdx))*eye(L,L);
        else
        W_          = W   (:,:,width_type(layIdx));
        V_          = V   (:,:,width_type(layIdx));
        Q_          = Q   (:,:,width_type(layIdx));
        iE          = invE(:,:,width_type(layIdx));
        end
        disp(['changing from layer ' num2str(layIdx-1) ' to layer ' num2str(layIdx) '  point : ' num2str(zz*1e9) ' nm, idx : ' num2str(zIdx)]);
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
        Xns     = ones(L,1); % 안 쓰인다.
    else
        z_start = acc_thick(layIdx-1);
        z_enddd = acc_thick(layIdx  );
        Xps     = exp( (zz-z_start) * Q_ );              % size of ( L by 1)
        Xns     = exp(-(zz-z_enddd) * Q_ );
    end

if strcmp(TETM, 'TM')    
    Sx_     = W_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx));
    Uy_     = V_ * (Xps.*Cgp(:,1,layIdx) - Xns.*Cgn(:,1,layIdx));
    Sz_     = -j*iE * (Kx .* Uy_) /k0;    
    
    Sx      = repmat(Sx_,1,xNum);
    Uy      = repmat(Uy_,1,xNum);
    Sz      = repmat(Sz_,1,xNum);

    Ex_     = sum(Sx .* exp_jk);
    Hy_     = j*sum(Uy .* exp_jk);
    Ez_     = sum(Sz .* exp_jk);

    Ex_Hx(zIdx,:) = Ex_;
    Hy_Ey(zIdx,:) = Hy_;
    Ez_Hz(zIdx,:) = Ez_;
elseif strcmp(TETM, 'TE')
    Sy_     = W_ * (Xps.*Cgp(:,1,layIdx) + Xns.*Cgn(:,1,layIdx));
    Ux_     = V_ * (Xps.*Cgp(:,1,layIdx) - Xns.*Cgn(:,1,layIdx));
    Uz_     = j * (Kx .* Sy_) /k0;    
    
    Sy      = repmat(Sy_,1,xNum);
    Ux      = repmat(Ux_,1,xNum);
    Uz      = repmat(Uz_,1,xNum);

    Ey_     = sum(Sy .* exp_jk);
    Hx_     = j*sum(Ux .* exp_jk);
    Hz_     = j*sum(Uz .* exp_jk);

    Hy_Ey(zIdx,:) = Ey_;
    Ex_Hx(zIdx,:) = Hx_;
    Ez_Hz(zIdx,:) = Hz_;
end


end
return