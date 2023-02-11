%% load cell info
Monitor_label_save = Monitor_cell{m_cnt,1};
monitor_type = Monitor_cell{m_cnt,2};
default_range = Monitor_cell{m_cnt,3};
range_row =  Monitor_cell{m_cnt,4};
range_col =  Monitor_cell{m_cnt,5};  
fixed_axis   = Monitor_cell{m_cnt,6};

%% set default range
if default_range == 1;
    if strcmp(monitor_type,'xz')
    range_row =  [-Tx/2 Tx/2];  range_col =  [-depth(1) acc_thick(end)];  
    elseif strcmp(monitor_type,'yz')
    range_row =  [-Tx/2 Tx/2];  range_col =  [-depth(1) acc_thick(end)];  
    elseif strcmp(monitor_type,'xy')
    range_row =  [-Tx/2 Tx/2];  range_col =  [-Tx/2 Tx/2]; 
    end    
end

%%
row_ = linspace(range_row(1),range_row(end),map_size_row);
col_ = linspace(range_col(1),range_col(end),map_size_col);

%% Calculate EM
%% TM
if strcmp(TETM,'TM')

    if strcmp(monitor_type,'xz')
    [Ex, Hy, Ez] = EM_field_xz_TMorTE(W__,V__,Q__,iE__,Cgp,Cgn,Kx,k0,row_,col_,acc_thick,layer_type,dc_profile);
    elseif strcmp(monitor_type,'yz')
    error(['아직 미구현!']);
    elseif strcmp(monitor_type,'xy')
    error(['아직 미구현!']);
    end

    Ex_(:,:,m_cnt,w_cnt) = Ex_(:,:,m_cnt,w_cnt) + Ex ; Hy_(:,:,m_cnt,w_cnt) = Hy_(:,:,m_cnt,w_cnt) + Hy ; Ez_(:,:,m_cnt,w_cnt) = Ez_(:,:,m_cnt,w_cnt) + Ez ;
% [Power_x Power_z] = power2D_from_Ex_Hy_Ez(Ex,Hy,Ez);
% save([Monitor_label_save, '.mat'],'Ex','Hy','Ez','row_','col_');

%% TE
elseif strcmp(TETM,'TE')
    if strcmp(monitor_type,'xz')
    [Hx, Ey, Hz] = EM_field_xz_TMorTE(W__,V__,Q__,iE__,Cgp,Cgn,Kx,k0,row_,col_,acc_thick,layer_type,dc_profile);
    elseif strcmp(monitor_type,'yz')
    error(['아직 미구현!']);
    elseif strcmp(monitor_type,'xy')
    error(['아직 미구현!']);
    end

    Hx_(:,:,m_cnt,w_cnt) = Hx_(:,:,m_cnt,w_cnt) + Hx ; Ey_(:,:,m_cnt,w_cnt) = Ey_(:,:,m_cnt,w_cnt) + Ey ; Hz_(:,:,m_cnt,w_cnt) = Hz_(:,:,m_cnt,w_cnt) + Hz ;

% [Power_x Power_z] = power2D_from_Ex_Hy_Ez(Ex,Hy,Ez);
% save([Monitor_label_save, '.mat'],'Hx','Ey','Hz','row_','col_');
%% both (+3D RCWA)
elseif strcmp(TETM,'both')
    if strcmp(monitor_type,'xz')
    [Ex, Ey, Ez, Hx, Hy, Hz] = EM_field_xz_both(W__,V__,Q__,iE__,Cgp,Cgn,Kx,Ky,k0,row_,fixed_axis,col_,acc_thick,layer_type,dc_profile);   
    elseif strcmp(monitor_type,'yz')
    [Ex, Ey, Ez, Hx, Hy, Hz] = EM_field_yz_both(W__,V__,Q__,iE__,Cgp,Cgn,Kx,Ky,k0,fixed_axis,row_,col_,acc_thick,layer_type,dc_profile);
    elseif strcmp(monitor_type,'xy')
    [Ex, Ey, Ez, Hx, Hy, Hz] = EM_field_xy_both(W__,V__,Q__,iE__,Cgp,Cgn,Kx,Ky,k0,row_,col_,fixed_axis,acc_thick,layer_type,dc_profile);
    end
    Ex_(:,:,m_cnt,w_cnt) = Ex_(:,:,m_cnt,w_cnt) + Ex ; Hy_(:,:,m_cnt,w_cnt) = Hy_(:,:,m_cnt,w_cnt) + Hy ; Ez_(:,:,m_cnt,w_cnt) = Ez_(:,:,m_cnt,w_cnt) + Ez ;
    Hx_(:,:,m_cnt,w_cnt) = Hx_(:,:,m_cnt,w_cnt) + Hx ; Ey_(:,:,m_cnt,w_cnt) = Ey_(:,:,m_cnt,w_cnt) + Ey ; Hz_(:,:,m_cnt,w_cnt) = Hz_(:,:,m_cnt,w_cnt) + Hz ;
% save([Monitor_label_save, '.mat'],'Ex','Ey','Ez','Hx','Hy','Hz','row_','col_');
end