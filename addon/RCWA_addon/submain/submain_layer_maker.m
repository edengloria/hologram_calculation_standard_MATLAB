if strcmp(Dimension,'2D')
[Epg_layer(:,:,lcnt), Apg_layer(:,:,lcnt)] = Layer_maker_1D (base_material(lcnt),build_num,build_eps_in,build_eps_out,block_width_x,block_shift_x);
elseif strcmp(Dimension,'3D')
    if strcmp(build_type,'Map')    
    [Epg_layer(:,:,lcnt), Apg_layer(:,:,lcnt)] = Layer_maker_2D_map (base_material(lcnt),build_num,build_eps_in,build_eps_out,map_shape_id);
    elseif strcmp(build_type,'Block')
    [Epg_layer(:,:,lcnt), Apg_layer(:,:,lcnt)] = Layer_maker_2D_block(base_material(lcnt),build_num,build_eps_in,build_eps_out,block_width_x,block_width_y,block_shift_x,block_shift_y);
    end
end
 lcnt = lcnt + 1;