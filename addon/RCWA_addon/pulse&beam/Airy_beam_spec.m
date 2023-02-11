function [kx_set weight] = Airy_beam_spec(nk0,beam_waist,a,beam_period,theta,k_set_size)

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
x0          = beam_waist;

k_step      = 2*pi/beam_period;
kx_set      = (-k_step*(k_set_size-1)/2:k_step:+k_step*(k_set_size-1)/2);

weight      = x0*exp(a^3/3).*exp(-i*a^2*x0*kx_set).*exp(-a*x0^2*kx_set.^2).*exp(i*x0^3*kx_set.^3/3);

% w_set
% k_step       = 2*pi/beam_period;
% kx_set_temp  = (-k_step*(d_len-1)/2:k_step:+k_step*(d_len-1)/2);
% kz_set_temp  = sqrt(nk0^2-kx_set_temp.^2);

% kx_set       = kx_set_temp*cos(theta)+kz_set_temp*sin(theta);
 end

