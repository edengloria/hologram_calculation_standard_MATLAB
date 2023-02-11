function [kx_set theta_set weight] = Bessel_beam_spec(nk0,alpha,beam_period,theta_start,theta_end)


%  if nargin < 5, k_set_size = 301; end
 
% kix        = 2*pi*3e8/lambda_center;
% if mod(w_center,2*pi/pulse_period_time) ~= 0
%     warning('center frequency is not integer multiple of 1/pulse_period');
% end
%  if k_set_size == 1
% kx_set      = nk0*sind(theta);
% weight      = 1;
% else
% step        = beam_period / (k_set_size - 1);
% x0          = beam_waist;

k_step      = 2*pi/beam_period;
k_num_start    = ceil(nk0*sind(theta_start)/k_step);
k_num_end      = floor(nk0*sind(theta_end)/k_step);


kx_set      = (k_step*k_num_start:k_step:+k_step*k_num_end);
theta_set   = asin(kx_set/nk0).*(imag(asin(kx_set/nk0))==0)  +100*(imag(asin(kx_set/nk0))~=0); 
dtheta      = zeros(size(theta_set));
dtheta(2:end-1) = (theta_set(3:end)-theta_set(1:end-2))/2;
dtheta(1)   = (theta_set(2)-theta_set(1));
dtheta(end)   = (theta_set(end)-theta_set(end-1));

weight      = exp(j*alpha*theta_set).*dtheta;


 end
