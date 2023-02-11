function [Cgp Cgn] = RCWA2D_ETMM_general_second(F,G,Wtemp,Vtemp,Cgpin,B,invA_X,k0,L, Total_layer_num);  

layer_num   = Total_layer_num-2;
layer_input = 1;
layer_first = 2;
layer_last  = Total_layer_num-1;
layer_ouput = Total_layer_num;


Cgp                             = zeros( L,1  ,Total_layer_num);
Cgn                             = zeros( L,1  ,Total_layer_num);
Cgp(:,:,layer_input)       = Cgpin;   % for plane wave normalization, use cosd(theta0)    

[Cgp(:,:,layer_first) Cgn(:,:,layer_input)]     = enhanced_T_at_first_boundary_col_new(F,G,Wtemp,0,Vtemp,k0,Cgp(:,:,layer_input));
for k = layer_first : layer_last
    [Cgn(:,:,k) Cgp(:,:,k+1)]                   = enhanced_T_from_first_to_last_col(B(:,:,k),invA_X(:,:,k),Cgp(:,:,k));
end

end
