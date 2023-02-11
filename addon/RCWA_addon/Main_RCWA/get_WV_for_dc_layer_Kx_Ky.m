function [Wtemp, Vtemp Kz] =get_WV_for_dc_layer_Kx_Ky(Kx,Ky,n0,k0)
global L;

Wtemp = eye(2*L,2*L);

KI  = zeros(2*L,2*L);

Kz          = sqrt((n0*k0)^2-Kx.^2-Ky.^2);
K11         = -Ky.*Kx./Kz;   
K12         = -((n0*k0)^2-Kx.^2)./Kz;
K21         = ((n0*k0)^2-Ky.^2)./Kz;
K22         = Kx.*Ky./Kz;


KI(1:L,1:L)         = diag(K11);
KI(1:L,L+1:2*L)     = diag(K12);
KI(L+1:2*L,1:L)     = diag(K21);
KI(L+1:2*L,L+1:2*L) = diag(K22);

Vtemp = KI/k0/j;
end