function [Wtemp, Vtemp Kz] =get_WV_for_dc_layer_Kx(Kx,n0,k0)
global TETM L;

Wtemp = eye(L,L);
Kz          = sqrt((n0*k0)^2-Kx.^2);
KI          = diag(((n0*k0)^2)./Kz);


if strcmp(TETM, 'TM'); 
    Vtemp = KI/k0/j; 
elseif strcmp(TETM, 'TE'); 
    Vtemp = diag(Kz)/k0*j; 
elseif strcmp(TETM, 'both');
    Vtemp = KI/k0/j;  % test
end    



end