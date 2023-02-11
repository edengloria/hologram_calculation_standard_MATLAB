function [NBx Nx L] = get_truncation_order_1D(Mx)
NBx    = 2 * Mx + 1;
Nx     = 4 * Mx + 1;
L      = NBx;