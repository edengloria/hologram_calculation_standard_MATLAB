%% SMM 1D 코드 - second part
%% S-matrix 좌우 combine
if strcmp(Dimension,'1D')

if strcmp(source_direction,'Foward') % 기존과 동일경우

set = 1:length(dc_profile)-1;
S_before_log = set < source_layer_num;
S_after_log = set >= source_layer_num;

if S_before_log(1) == 0; S_before = eye(2,2); else S_before = S_mat(:,:,1); end 
if S_after_log(1) == 0; S_after = eye(2,2); else S_after = S_mat(:,:,1); end 

S_total = S_mat(:,:,1); 
for cnt = 1:length(dc_profile)-2
if S_before_log(cnt+1) == 0; S_next_before = eye(2,2); depth_before = 0; else S_next_before = S_mat(:,:,cnt+1); depth_before = depth(cnt+1); end 
if S_after_log(cnt+1) == 0; S_next_after = eye(2,2); depth_after = 0;else S_next_after = S_mat(:,:,cnt+1); depth_after = depth(cnt+1); end

S_before = SMM_nonzero_normal(S_before,S_next_before,depth_before,dc_profile(cnt+1),1,lambda);
S_after    = SMM_nonzero_normal(S_after,S_next_after,depth_after,dc_profile(cnt+1),1,lambda);
% S_total = SMM_nonzero_normal(S_total,S_mat(:,:,cnt+1),depth(cnt+1),dc_profile(cnt+1),1,lambda);
end

n_ratio_be = real(sqrt(dc_profile(1))/sqrt(dc_profile(source_layer_num)));
n_ratio_af  = real(sqrt(dc_profile(end))/sqrt(dc_profile(source_layer_num)));
end

total_R = n_ratio_be*abs(S_before(2,2)*S_after(2,1)/(1-S_after(2,1)*S_before(1,2))).^2;
R_SMM = total_R;

end