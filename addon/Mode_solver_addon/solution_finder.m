function [sol_cnt sol_set sign_ff] = solution_finder(f,beta_r,beta_i)

signreal_f_ = sign(real(f));
[signreal_fx signreal_fy] = gradient(signreal_f_);
signreal_ff = signreal_fx | signreal_fy;
signimag_f_ = sign(imag(f));
[signimag_fx signimag_fy] = gradient(signimag_f_);
signimag_ff = signimag_fx | signimag_fy;
sign_ff= 1* signreal_ff + 2*signimag_ff;

len_beta_r = length(beta_r);
len_beta_i = length(beta_i);

sol_cnt = 0;
sol_set = [];
for p=1:len_beta_r
    for q=1:len_beta_i
        if sign_ff(q,p) == 3
            sol_cnt = sol_cnt + 1;
            sol_set(sol_cnt) = beta_r(p) + i*beta_i(q);
        end
    end
end
sol_set = sol_set.';
