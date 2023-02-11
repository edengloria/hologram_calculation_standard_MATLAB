function [kx_set weight] = Gaussian_beam_spec(nk0,beam_waist,beam_period,theta,k_set_size)


 if nargin < 5, k_set_size = 301; end
 
% kix        = 2*pi*3e8/lambda_center;
% if mod(w_center,2*pi/pulse_period_time) ~= 0
%     warning('center frequency is not integer multiple of 1/pulse_period');
% end
 if k_set_size == 1
kx_set      = nk0*sin(theta);
weight      = 1;
 else
step        = beam_period / (k_set_size - 1);
xx          = (-beam_period/2 : step : beam_period/2);
% x           = 3e8 * t;
P           = exp(-(xx).^2/(beam_waist)^2);
%% old version
% Fourier transform -> weight
% a=odd_fftshift(P,1,length(P));
% b=fft(a,length(a));
% d=odd_ifftshift(b,1,length(P));

%% new version 2022/08/03
d =fftshift(fft(ifftshift(P)));


d_len=length(d);
weight = zeros(1,d_len);
 
for k=1:d_len
    weight(k)=(d(k)/d_len);
end
% w_set
k_step       = 2*pi/beam_period;
kx_set_temp  = (-k_step*(d_len-1)/2:k_step:+k_step*(d_len-1)/2);
kz_set_temp  = sqrt(nk0^2-kx_set_temp.^2);

kx_set       = kx_set_temp*cos(theta)+kz_set_temp*sin(theta);
 end
