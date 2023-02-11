function S = SMM_zero_normal(input_eps,output_eps,input_mu,output_mu)
%   Saleh Ch.7  기준     S = [ t12   r21;  r12  t21];  
                                  
eta_i = sqrt(input_mu./input_eps);
eta_o = sqrt(output_mu./output_eps);

S21 = (eta_o-eta_i)./(eta_o+eta_i);  % r12
S12 = (eta_i-eta_o)./(eta_i+eta_o);  % r21
S11 = S21 + 1;                          % t12
S22 = S12 + 1;                          % t21

S = [S11 S12; S21 S22];
end