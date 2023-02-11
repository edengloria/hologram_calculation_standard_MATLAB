function [kx_set weight_x weight_y] = Dipole_spec(nk0,dipole_period,k_set_size,ky,J_component)

 if nargin < 5, k_set_size = 301; end
 
% kix        = 2*pi*3e8/lambda_center;
% if mod(w_center,2*pi/pulse_period_time) ~= 0
%     warning('center frequency is not integer multiple of 1/pulse_period');
% end
 if k_set_size == 1
kx_set      = nk0*sind(theta);
weight      = 1;
else
% step        = beam_period / (k_set_size - 1);
% x0          = beam_waist;

k_step      = 2*pi/dipole_period;
kx_set      = (-k_step*(k_set_size-1)/2:k_step:+k_step*(k_set_size-1)/2);
kz = sqrt(nk0^2-kx_set.^2-ky^2);

weight_x      = 1/nk0*((nk0^2-kx_set.^2)./kz*J_component(1) - kx_set*ky./kz*J_component(2)- kx_set*J_component(3));
weight_y      = 1/nk0*(- kx_set*ky./kz*J_component(1) - (nk0^2-ky^2)./kz*J_component(2)- ky*J_component(3));
% w_set
% k_step       = 2*pi/beam_period;
% kx_set_temp  = (-k_step*(d_len-1)/2:k_step:+k_step*(d_len-1)/2);
% kz_set_temp  = sqrt(nk0^2-kx_set_temp.^2);

% kx_set       = kx_set_temp*cos(theta)+kz_set_temp*sin(theta);
 end

