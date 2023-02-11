function errorcheck_layers(Total_layer_num,depth,width_type,dc_profile,material_type_num,base_material,pml_);

if (Total_layer_num == length(depth)) && (Total_layer_num == length(width_type)) && (Total_layer_num == length(dc_profile)) 
else
    error('Check the Total_layer_num and length of depth, width_type, dc_profile are equal');
end
    
if (material_type_num == length(base_material)) && (material_type_num == length(pml_)) 
else
    error('Check the material_type_num and length of base_material, pml_ are equal');
end

if sum(abs(width_type.*dc_profile)) == 0
else
    error('Check width_type or dc_profile: One of them must be zero');
end
    
