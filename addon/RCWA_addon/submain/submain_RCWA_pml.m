%% 2D RCWA
if Dimension     == '2D' 
for cnt=1:layer_type_num
    if pml_(cnt)==0 % no pml
    elseif pml_(cnt)==3 % cpml
        Epg_layer(:,:,cnt) = Epg_layer(:,:,cnt) +Fourier_coeff_1D_rect(  base_material(cnt)/f_pml-  base_material(cnt)  ,0,2*pml_width   ,Tx/2   ,Nx,Tx);
        Apg_layer(:,:,cnt) = Apg_layer(:,:,cnt) +Fourier_coeff_1D_rect(1/base_material(cnt)/f_pml-  1/base_material(cnt),0,2*pml_width   ,Tx/2   ,Nx,Tx);
        Bpg_layer(:,:,cnt) = Bpg_layer(:,:,cnt) +Fourier_coeff_1D_rect(                   1/f_pml-                     1,0,2*pml_width   ,Tx/2   ,Nx,Tx);
    else  % seyoon pml
        Epg_layer(:,:,cnt) = build_PML(pml_width,pml_N,Tx,Mx,sqrt(base_material(cnt))  ,Epg_layer(:,:,cnt),0);
        Apg_layer(:,:,cnt) = build_PML(pml_width,pml_N,Tx,Mx,sqrt(base_material(cnt))  ,Apg_layer(:,:,cnt),1);   %o
%         Epg_layer(:,:,cnt) = build_PML(pml_width,pml_N,Tx,Mx,(base_material(cnt))  ,Epg_layer(:,:,cnt),0);
%         Apg_layer(:,:,cnt) = build_PML(pml_width,pml_N,Tx,Mx,(base_material(cnt))  ,Apg_layer(:,:,cnt),1);   %x 
    end
end


%% 3D RCWA
elseif Dimension    == '3D' 
for cnt=1:layer_type_num
    if pml_(cnt)==0 % no pml
    elseif pml_(cnt)==3  % y-directional pml
     [Epg_layer(:,:,cnt) Apg_layer(:,:,cnt)] =  PRCWA_Gen_PML2D_only_y(pml_width,pml_N,sqrt(base_material(cnt)),Nx,Ny,Tx,Ty);
    else % seyoon pml   
     [tempE tempA] =  PRCWA_Gen_PML2D(pml_width,pml_N,sqrt(base_material(cnt)),Nx,Ny,Tx,Ty);
     Epg_layer(:,:,cnt) = tempE - Fourier_coeff_2D_dc  (Ny,Nx,  sqrt(base_material(cnt))) + Epg_layer(:,:,cnt);
     Apg_layer(:,:,cnt) = tempA - Fourier_coeff_2D_dc  (Ny,Nx,1/sqrt(base_material(cnt))) + Apg_layer(:,:,cnt);
    end
end
end