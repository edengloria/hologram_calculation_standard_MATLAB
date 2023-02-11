function Epsl = Fourier_coeff_2D_rect(epsl_in,epsl_out,width_x,width_y,shift_x,shift_y,N_x,N_y,gambda_x,gambda_y)

[grid_fy, grid_fx, df_x, df_y] = Fourier_coeff_2D_general_grid(N_x,N_y,gambda_x,gambda_y); % make real space and Fourier space


[size_x size_y]         = size(grid_fx);
center_x                = (size_x-1)/2+1;
center_y                = (size_y-1)/2+1;


Epsl = zeros(N_x,N_y);
Epsl = (epsl_in - epsl_out) * (width_x * width_y) ...
    .* sinc(width_x.*grid_fx) .* sinc(width_y.*grid_fy);
Epsl                    = Epsl * df_x * df_y; 

Epsl = Fourier_coeff_2D_shift(Epsl,shift_x,shift_y,N_x,N_y,gambda_x,gambda_y);

Epsl(center_x,center_y)   = Epsl(center_x,center_y) + epsl_out;

clear grid_fy grid_fx df_x df_y;