function [output_E, output_A]= Layer_maker_2D_block (dc_eps,block_num,block_eps_in,block_eps_out,block_width_x,block_width_y,block_shift_x,block_shift_y)
global Ny Nx Ty Tx;

output_E = zeros(Ny,Nx);
output_A = zeros(Ny,Nx);

if block_num == 0
output_E(ceil(Ny/2),ceil(Nx/2)) = dc_eps;
output_A(ceil(Ny/2),ceil(Nx/2)) = 1/dc_eps;
     disp('Notice: block_number is 0, this is homogeneous material!');
elseif block_num ~= 0
condition_x = (block_num == length(block_width_x)) && (block_num == length(block_shift_x)) && (block_num == length(block_eps_in)) && (block_num == length(block_eps_out)); 
condition_y = (block_num == length(block_width_y)) && (block_num == length(block_shift_y)); 
 if condition_x && condition_y
     output_E(ceil(Ny/2),ceil(Nx/2)) = dc_eps;
     output_A(ceil(Ny/2),ceil(Nx/2)) = 1/dc_eps;
     for cnt = 1:1:block_num
         output_E = output_E + Fourier_coeff_2D_rect(  block_eps_in(cnt) ,block_eps_out(cnt), block_width_x(cnt) ,block_width_y(cnt) ,block_shift_x(cnt), block_shift_y(cnt),Nx,Ny,Tx,Ty);
         output_A = output_A + Fourier_coeff_2D_rect(1/block_eps_in(cnt) ,1/block_eps_out(cnt), block_width_x(cnt) ,block_width_y(cnt) ,block_shift_x(cnt), block_shift_y(cnt) ,Nx,Ny,Tx,Ty);
     end
     
 else
     error('Error: Check build_number is equal to the size of build_eps or block_width or block_shift');
 end
end
end


