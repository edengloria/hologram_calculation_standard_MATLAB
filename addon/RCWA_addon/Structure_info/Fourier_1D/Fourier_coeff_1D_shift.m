function Epsl_out = Fourier_coeff_1D_shift(Epsl_in,Nx,gambda,shift)

% shift
NB_x         = (Nx - 1) / 2 + 1;
prime      = [-(NB_x-1):1:+(NB_x-1)];

shift_factor = exp(-j * 2 * pi * (1/gambda*prime*shift));
Epsl_out     = Epsl_in .* shift_factor;

end
