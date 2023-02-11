%%
if layer_type(1) == 0 && layer_type(end) == 0
    cal_mode = 'dc-to-dc'; 
elseif layer_type(1) == 0 && layer_type(end) ~= 0
    cal_mode = 'dc-to-waveguide' ;   
elseif layer_type(1) ~= 0 && layer_type(end) == 0
    cal_mode = 'waveguide-to-dc';
else
    cal_mode = 'waveguide-to-waveguide';
end
% disp(['calculation mode is set to ',cal_mode]);



%%
if strcmp(Dimension,'2D')
        if strcmp(TETM,'TM') | strcmp(TETM,'TE')
[F,G,Wtemp,Vtemp,B,invA_X] = RCWA2D_ETMM_general_first_TMorTE(W__, Q__, V__, depth,layer_type,Total_layer_num,L,k0,Kx,dc_profile); 
        elseif strcmp(TETM,'both')
[F,G,Wtemp,Vtemp,B,invA_X] = RCWA2D_ETMM_general_first_TMandTE(W__, Q__, V__, depth,layer_type,Total_layer_num,L,k0,Kx,ky,dc_profile); 
        else
        end
elseif strcmp(Dimension,'3D')
[F,G,Wtemp,Vtemp,B,invA_X] = RCWA3D_ETMM_general_first(W__, Q__, V__, depth,layer_type,Total_layer_num,L,k0,Kx,Ky,dc_profile);  
else
end