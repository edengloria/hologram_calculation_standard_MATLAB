if Monitor_cell{m_cnt,3}
    if strcmp(monitor_type,'xz')
    range_row =  [-Tx/2 Tx/2];  range_col =  [-depth(1) acc_thick(end)];  
    elseif strcmp(monitor_type,'yz')
    range_row =  [-Tx/2 Tx/2];  range_col =  [-depth(1) acc_thick(end)];  
    elseif strcmp(monitor_type,'xy')
    range_row =  [-Tx/2 Tx/2];  range_col =  [-Ty/2 Ty/2]; 
    end    
else 
range_row =  Monitor_cell{m_cnt,4};
range_col =   Monitor_cell{m_cnt,5}; 
end

row_ = linspace(range_row(1),range_row(end),map_size_row);
col_ = linspace(range_col(1),range_col(end),map_size_col);

if strcmp(TETM,'TM')
Ex_final = Ex_(:,:,m_cnt,:); Ez_final = Ez_(:,:,m_cnt,:); Hy_final = Hy_(:,:,m_cnt,:);  
save([Monitor_cell{m_cnt,1}, '.mat'],'Ex_final','Hy_final','Ez_final','row_','col_');   
elseif strcmp(TETM,'TE')
Hx_final = Hx_(:,:,m_cnt,:); Hz_final = Hz_(:,:,m_cnt,:); Ey_final = Ey_(:,:,m_cnt,:); 
save([Monitor_cell{m_cnt,1}, '.mat'],'Hx_final','Ey_final','Hz_final','row_','col_'); 
elseif strcmp(TETM,'both')
Ex_final = Ex_(:,:,m_cnt,:); Ez_final = Ez_(:,:,m_cnt,:); Hy_final = Hy_(:,:,m_cnt,:);  
Hx_final = Hx_(:,:,m_cnt,:); Hz_final = Hz_(:,:,m_cnt,:); Ey_final = Ey_(:,:,m_cnt,:); 
save([Monitor_cell{m_cnt,1}, '.mat'],'Ex_final','Hy_final','Ez_final','Hx_final','Ey_final','Hz_final','row_','col_'); 
end
