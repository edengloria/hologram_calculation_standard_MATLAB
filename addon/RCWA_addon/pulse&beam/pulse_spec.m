function [w_set weight] = pulse_spec(lambda_center,pulse_duration_time,pulse_period_time,w_set_size)


if nargin < 4, w_set_size = 301; end

w_center        = 2*pi*2.99792458 * 10^8/lambda_center;
if mod(w_center,2*pi/pulse_period_time) ~= 0
    warning('center frequency is not integer multiple of 1/pulse_period');
end
 if w_set_size == 1
w_set      = w_center;
weight      = 1;
disp(['파장은 ' num2str(lambda_center*1e9) ' 인 monochromatic wave  (nm)']);
 else
time_step   = pulse_period_time / (w_set_size - 1);
t           = (-pulse_period_time/2 : time_step : pulse_period_time/2);
% x           = 3e8 * t;
P           = exp(-t.^2/(pulse_duration_time)^2);

% Fourier transform -> weight
a=fftshift(P);
b=fft(a);
d=ifftshift(b);
d_len=length(d);
weight = zeros(1,d_len);
for k=1:d_len
    weight(k)=d(k)/d_len;
end
figure(61)
plot(real(weight));
% w_set
w_step      = 2*pi/pulse_period_time;
w_set       = (w_center-w_step*(d_len-1)/2:w_step:w_center+w_step*(d_len-1)/2);

lambda_set=2*pi*2.99792458 * 10^8./w_set;
pulse_period_lent = 3e8*pulse_period_time;
pulse_duration_lent = 3e8*pulse_duration_time;
disp(['파장은 ' num2str(lambda_set(end)*1e9) ' 부터 ' num2str(lambda_set(1)*1e9) ' 까지  (nm)']);
disp(['펄스 주기는 ' num2str(pulse_period_time*1e15) ' (fs). 공간으로는 ' num2str(pulse_period_lent*1e6) ' (um) 입니다']);
disp(['펄스 폭은   ' num2str(pulse_duration_time*1e15) ' (fs). 공간으로는 ' num2str(2*pulse_duration_lent*1e6) ' (um) 입니다']);
 end





