function CGH_pattern_FFT = hologram_shift_FFT_domain(CGH_pattern_FFT,shift_xyz,u,v);
global lambda;
if shift_xyz(3) == 0 % no z_shift
CGH_pattern_FFT = CGH_pattern_FFT.*exp( - j * 2 * pi * (shift_xyz(1) * u +  shift_xyz(2) * v));
else
w = sqrt(1/lambda^2-(u).^2 - (v).^2);
CGH_pattern_FFT = CGH_pattern_FFT.*exp( j * 2 * pi * w * shift_xyz(3)).*exp( - j * 2 * pi * (shift_xyz(1) * u +  shift_xyz(2) * v));    
end