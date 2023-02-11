Monitor_cell = cell(monitor_num,6);

if ~exist('w_set'); w_set = w0; w_cnt = 1; end

if strcmp(TETM,'TM')
Ex_ = zeros(map_size_col,map_size_row,monitor_num,length(w_set));
Ez_ = Ex_; Hy_ = Ex_;

elseif strcmp(TETM,'TE')
Hx_ = zeros(map_size_col,map_size_row,monitor_num,length(w_set));
Hz_ = Hx_; Ey_ = Hx_;

elseif strcmp(TETM,'both')
Ex_ = zeros(map_size_col,map_size_row,monitor_num,length(w_set));
Ey_ = Ex_; Ez_ = Ex_; Hx_ = Ex_; Hy_ = Ex_; Hz_ = Ex_;
end