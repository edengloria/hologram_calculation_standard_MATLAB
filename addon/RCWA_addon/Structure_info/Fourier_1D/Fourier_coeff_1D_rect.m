function Epsl = Fourier_coeff_1D_rect(epsl_in,epsl_out,width_x,shift_x,N_x,gambda_x)

% Real space
d_x = gambda_x / N_x;  % step
% x  = [-gambda_x/2 + d_x/2 : d_x : +gambda_x/2 - d_x/2]; % x space

% Fourier space
F_x  = 1/d_x;   df_x = F_x/N_x;
f_x = [-F_x/2 + df_x/2 : df_x : +F_x/2 - df_x/2];

center = (N_x-1)/2+1;

Epsl = (epsl_in - epsl_out) * width_x .* sinc(width_x.*f_x);
Epsl = Epsl * df_x;
% Epsl(center) = Epsl(center,center) + epsl_out;% * (width_x * width_y);
% Epsl(center) = epsl_out * ((gambda_x-width_x)/gambda_x) + epsl_in * width_x/gambda_x;
Epsl(center) = (epsl_in - epsl_out) * width_x/gambda_x;
Epsl = Fourier_coeff_1D_shift(Epsl,N_x,gambda_x,shift_x);

end