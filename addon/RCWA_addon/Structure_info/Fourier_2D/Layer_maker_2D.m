function [output_E, output_A]= Layer_maker_2D (dc_eps,map_num,map_eps_in,map_eps_out,map_shape)
global Ny Nx Tx Ty;

output_E = zeros(Ny,Nx);
output_A = zeros(Ny,Nx);

output_E(ceil(Ny/2),ceil(Nx/2)) = dc_eps;
output_A(ceil(Ny/2),ceil(Nx/2)) = 1/dc_eps; 
%  
if map_num == 0
 disp('Notice: map_number is 0, this is homogeneous material!');
elseif map_num ~= 0
    for cnt = 1:1:map_num
    map = imresize(double(imread(map_shape(cnt))),[Ny Nx]);

    map = fftshift(fft2(fftshift(map)));

    
     output_E= output_E + (map_eps_in(cnt) - map_eps_out(cnt)) * map/Ny/Nx;
     output_A= output_A + (1/map_eps_in(cnt) - 1/map_eps_out(cnt)) * map /Ny/Nx;
        
    end
end

% if block_num == 0
% output_E(1,ceil(Nx/2)) = dc_eps;
% output_A(1,ceil(Nx/2)) = 1/dc_eps;
%      disp('Notice: block_number is 0, this is homogeneous material!');
% elseif block_num ~= 0
%  if (block_num == length(block_width)) && (block_num == length(block_shift)) && (block_num == length(block_eps_in)) && (block_num == length(block_eps_out))
%      output_E(1,ceil(Nx/2)) = dc_eps;
%      output_A(1,ceil(Nx/2)) = 1/dc_eps;
%      for cnt = 1:1:block_num
%          output_E = output_E + Fourier_coeff_1D_rect(  block_eps_in(cnt) ,block_eps_out(cnt), block_width(cnt) ,block_shift(cnt) ,Nx,Tx);
%          output_A = output_A + Fourier_coeff_1D_rect(1/block_eps_in(cnt) ,1/block_eps_out(cnt), block_width(cnt) ,block_shift(cnt) ,Nx,Tx);
%      end
%      
%  else
%      error('Error: Check block_number is equal to the size of block_eps or block_width or block_shift');
%  end
% end
end


