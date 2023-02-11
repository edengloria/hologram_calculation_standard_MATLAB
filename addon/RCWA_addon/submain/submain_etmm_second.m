if  strcmp(Dimension,'2D')
    if strcmp(TETM,'TM') | strcmp(TETM,'TE')
[Cgp Cgn] = RCWA2D_ETMM_general_second(F,G,Wtemp,Vtemp,Cgpin,B,invA_X,k0,L, Total_layer_num);  
    elseif strcmp(TETM,'both')
[Cgp Cgn] = RCWA2D_ETMM_general_second_TEandTM(F,G,Wtemp,Vtemp,Cgpin,B,invA_X,k0,L, Total_layer_num);  
    else
    end
elseif strcmp(Dimension,'3D')
[Cgp Cgn] = RCWA3D_ETMM_general_second(F,G,Wtemp,Vtemp,Cgpin,B,invA_X,k0,L, Total_layer_num);  
else
end