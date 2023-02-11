function [NBx NBy Nx Ny L] = get_truncation_order_2D(Mx,My)
NBx    = 2 * Mx + 1;
Nx     = 4 * Mx + 1;

NBy    = 2 * My + 1; % y. as same as x
Ny     = 4 * My + 1;
L      = NBx * NBy;