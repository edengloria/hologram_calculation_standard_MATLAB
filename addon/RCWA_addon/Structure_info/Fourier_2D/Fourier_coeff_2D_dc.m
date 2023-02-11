function output = Fourier_coeff_2D_dc   (size_x,size_y,value)

output = zeros(size_x,size_y);
output(ceil(size_x/2),ceil(size_y/2)) = value;
