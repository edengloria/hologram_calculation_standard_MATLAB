function S = SMM_nonzero_normal(S_in,S_out,distance,mid_eps,mid_mu,lambda) %Airy's fomula

k0 = 2*pi/lambda;
n_mid = sqrt(mid_eps);

S11 = S_in(1,1)*S_out(1,1)*exp(j*k0*n_mid*distance)/(1-S_in(1,2)*S_out(2,1)*exp(j*2*k0*n_mid*distance));
S21 = S_in(2,1) + S_in(1,1)*S_in(2,2)*S_out(2,1)*exp(j*2*k0*n_mid*distance)/(1-S_in(1,2)*S_out(2,1)*exp(j*2*k0*n_mid*distance));
S12 = S_out(1,2) + S_out(1,1)*S_out(2,2)*S_in(1,2)*exp(j*2*k0*n_mid*distance)/(1-S_in(1,2)*S_out(2,1)*exp(j*2*k0*n_mid*distance));
S22 = S_out(2,2)*S_in(2,2)*exp(j*k0*n_mid*distance)/(1-S_in(1,2)*S_out(2,1)*exp(j*2*k0*n_mid*distance));

S = [S11 S12; S21 S22];
end