if strcmp(Dimension ,'1D')




else
if strcmp(cal_mode ,'dc-to-dc') || strcmp(cal_mode ,'dc-to-waveguide')
    if strcmp(TETM,'TE') || strcmp(TETM,'TM')
    [W_i, V_i, dummy] = get_WV_for_dc_layer_Kx(Kx, sqrt(dc_profile(1)),k0);
    elseif strcmp(TETM,'both')
    if strcmp(Dimension,'2D');  Ky = repmat(ky,[length(Kx) 1]);  end
    [W_i, V_i, dummy] = get_WV_for_dc_layer_Kx_Ky(Kx, Ky, sqrt(dc_profile(1)),k0);
    end
else
W_i = W__(:,:,layer_type(1)); V_i = V__(:,:,layer_type(1));    
end

if strcmp(cal_mode ,'dc-to-dc') || strcmp(cal_mode ,'waveguide-to-dc')
    if strcmp(TETM,'TE') || strcmp(TETM,'TM')    
    [W_o, V_o, dummy] = get_WV_for_dc_layer_Kx(Kx, sqrt(dc_profile(end)),k0);
    elseif strcmp(TETM,'both')
    if strcmp(Dimension,'2D');  Ky = repmat(ky,[length(Kx) 1]);  end  
    [W_o, V_o, dummy] = get_WV_for_dc_layer_Kx_Ky(Kx, Ky, sqrt(dc_profile(end)),k0);
    end
else
W_o = W__(:,:,layer_type(end)); V_o = V__(:,:,layer_type(end));
end
end