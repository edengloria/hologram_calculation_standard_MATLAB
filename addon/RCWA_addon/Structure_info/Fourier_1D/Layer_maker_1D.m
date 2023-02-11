function [output_E, output_A]= Layer_maker_1D (dc_eps,block_num,block_eps_in,block_eps_out,block_width,block_shift)
global Nx Tx;

output_E = zeros(1,Nx);
output_A = zeros(1,Nx);

if block_num == 0
output_E(1,ceil(Nx/2)) = dc_eps;
output_A(1,ceil(Nx/2)) = 1/dc_eps;
     disp('Notice: block_number is 0, this is homogeneous material!');
elseif block_num ~= 0
 if (block_num == length(block_width)) && (block_num == length(block_shift)) && (block_num == length(block_eps_in)) && (block_num == length(block_eps_out))
     output_E(1,ceil(Nx/2)) = dc_eps;
     output_A(1,ceil(Nx/2)) = 1/dc_eps;
     for cnt = 1:1:block_num
         output_E = output_E + Fourier_coeff_1D_rect(  block_eps_in(cnt) ,block_eps_out(cnt), block_width(cnt) ,block_shift(cnt) ,Nx,Tx);
         output_A = output_A + Fourier_coeff_1D_rect(1/block_eps_in(cnt) ,1/block_eps_out(cnt), block_width(cnt) ,block_shift(cnt) ,Nx,Tx);
     end
     
 else
     error('Error: Check build_number is equal to the size of build_eps or block_width or block_shift');
 end
end


