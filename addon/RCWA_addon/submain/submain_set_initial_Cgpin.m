if layer_type(1) == 0

%% dc input    
center_1       = (L+1)/2; center_2       = (L+1)/2 +L;
if strcmp(TETM,'TM')
Cgpin(center_1,1) = cosd(theta_x)*input_polarization(1); % x-pol case electric field
elseif strcmp(TETM,'TE')
Cgpin(center_1,1) = input_polarization(2);    
elseif strcmp(TETM,'both')    
Cgpin(center_1,1) = cosd(theta_x)*input_polarization(1); % x-pol case electric field
Cgpin(center_2,1) = input_polarization(2); % y-pol case electric field - only used in both
end



else
%% mode input    
[a,mode_sel] = min(abs(ei-mode_ei)); 
Cgpin(mode_sel,1) = input_weight; 
disp(['mode_sel : ',num2str(mode_sel) ]);
end