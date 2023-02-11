function result = char_eq(ep,mu,gamma,d,k0,beta,leaky_left,leaky_right)

if nargin == 6
    leaky_left = 1;
    leaky_right = 1;
end

N       = length(ep);

size1   = size(beta,1);
size2   = size(beta,2);

%%
A1      = ones(size1,size2);
A2      = -sqrt(beta.^2 - ep(1).*mu(1))/gamma(1);
A2      = A2 * leaky_left;
for q=2:N-1
    kx      = sqrt(beta.^2 - ep(q).*mu(q));
    eta     = kx/gamma(q);
    xsi     = exp( k0*d(q)/2*kx);% growing
    xsi_    = exp(-k0*d(q)/2*kx);% decaying

    R11     = xsi;
    R12     = xsi_;
    R21     = xsi.*kx/gamma(q);
    R22     = -xsi_.*kx/gamma(q);
    R_ad_bc = R11.*R22 - R12.*R21;
    
    A1_     = ( R22.*A1 - R12.*A2)./R_ad_bc;
    A2_     = (-R21.*A1 + R11.*A2)./R_ad_bc;
    
    L11     = xsi_;
    L12     = xsi;
    L21     = xsi_.*kx/gamma(q);
    L22     = -xsi.*kx/gamma(q);

    A1__    = L11.*A1_ + L12.*A2_;
    A2__    = L21.*A1_ + L22.*A2_;
    
    A1      = A1__;
    A2      = A2__;
end
B1      = ones(size1,size2);
B2      =  sqrt(beta.^2 - ep(N).*mu(N))/gamma(N);
B2      = B2 * leaky_right;

result  = B1.*A2 - B2.*A1;

return