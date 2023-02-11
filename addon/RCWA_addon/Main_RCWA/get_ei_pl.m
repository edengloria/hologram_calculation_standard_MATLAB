function [ei pl] = get_ei_pl(q,k0)

ei      = imag(q/k0);
pl      = 1e6 * (-real(q)).^(-1);   % um scale

return