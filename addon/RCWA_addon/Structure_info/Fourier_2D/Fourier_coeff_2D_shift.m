function Epsl_out = Fourier_coeff_2D_shift(Epsl_in,shift_x,shift_y,N_x,N_y,gambda_x,gambda_y)

Epsl_out    = Epsl_in;

% shift
NB_x        = (N_x - 1) / 2 + 1;
NB_y        = (N_y - 1) / 2 + 1;
% prime_x     = [-(NB_x-1):1:+(NB_x-1)];
% prime_y     = [-(NB_y-1):1:+(NB_y-1)].';
prime_x     = [-(NB_x-1):1:+(NB_x-1)].';
prime_y     = [-(NB_y-1):1:+(NB_y-1)];
shift_x     = exp(-j * 2 * pi * (1/gambda_x*prime_x*shift_x));
shift_y     = exp(-j * 2 * pi * (1/gambda_y*prime_y*shift_y));
% Epsl_out    = Epsl_out .* repmat(shift_x,N_y,1);
% Epsl_out    = Epsl_out .* repmat(shift_y,1,N_x);
Epsl_out    = Epsl_out .* repmat(shift_y,N_x,1);
Epsl_out    = Epsl_out .* repmat(shift_x,1,N_y);

clear prime_x;
clear prime_y;
clear shift_x;
clear shift_y;
