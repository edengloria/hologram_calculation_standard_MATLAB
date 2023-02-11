function output = Fourier_coeff_1D_dc   (size_x,value)

output = zeros(1,size_x);
output(1,ceil(size_x/2)) = value;
