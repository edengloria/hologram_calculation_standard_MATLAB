function [Cgn_this Cgp_next] = enhanced_T_from_first_to_last_col(B,invA_X,Cgp_this)
Cgp_next = invA_X * Cgp_this;
Cgn_this = B * Cgp_next;
