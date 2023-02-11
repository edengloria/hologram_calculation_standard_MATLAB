function [Mt kx] = char_mat(ep,mu,gamma,d,k0,sol,leaky_left,leaky_right)

if nargin == 6
    leaky_left = 1;
    leaky_right = 1;
end

N       = length(ep);
kx      = sqrt(sol^2 - ep.*mu);
kx(1)   = kx(1) * leaky_left;
kx(N)   = kx(N) * leaky_right;


xsi     = exp( k0/2*d.*kx);
xsi_    = exp(-k0/2*d.*kx);
%%
for q=1:N
    T (:,:,q)   = [1 1;kx(q)/gamma(q) -kx(q)/gamma(q)];
    Ma(:,:,q)   =  T(:,:,q) * [xsi_(q) 0; 0 xsi(q) ];
    Mb(:,:,q)   = -T(:,:,q) * [xsi(q)  0; 0 xsi_(q)];
end
%%
for q=1:N-1
    pos         = (q-1)*2;
    Mt_temp(pos+1:pos+2,pos+1:pos+4) = [Ma(:,:,q) Mb(:,:,q+1)];
end
%%
Mt              = Mt_temp(1:end,2:end-1);
% if nargout == 2
%     Mt_1        = -Mt_temp(1:end,1);
% end



