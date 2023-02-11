function [grid_fy, grid_fx, df_x, df_y] = Fourier_coeff_2D_general_grid(N_x,N_y,gambda_x,gambda_y)
% This routine is adopted for all 2D Fourier expansion.


% real space
d_x = gambda_x / N_x;  % step
x  = [-gambda_x/2 + d_x/2 : d_x : +gambda_x/2 - d_x/2]; % x space
% y, as same as in x
d_y = gambda_y / N_y;  % step
y  = [-gambda_y/2 + d_y/2 : d_y : +gambda_y/2 - d_y/2]; % y space


% Fourier space
F_x  = 1/d_x;
df_x = F_x/N_x;
f_x = [-F_x/2 + df_x/2 : df_x : +F_x/2 - df_x/2];
% y, as same as in x
F_y  = 1/d_y;
df_y = F_y/N_y;
f_y = [-F_y/2 + df_y/2 : df_y : +F_y/2 - df_y/2];

% [grid_fx,grid_fy] = meshgrid(f_x,f_y);
[grid_fy,grid_fx] = meshgrid(f_y,f_x);

clear N_x N_y d_x x d_y y F_x f_x F_y f_y;