function [F G] = enhanced_T_at_last_boundary_col(W,V,k0)
F = W;
% G = V;
G = j*k0*V;
