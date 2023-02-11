%% SMM 1D 코드
%% 각 layer의 S-Matrix 마련한다
if strcmp(Dimension,'1D')
mu_dc_profile = ones(size(dc_profile));

S_mat = zeros(2,2,length(dc_profile)-1);

for cnt = 1:length(dc_profile)-1
S_mat(:,:,cnt) = SMM_zero_normal(dc_profile(cnt),dc_profile(cnt+1),mu_dc_profile(cnt),mu_dc_profile(cnt+1));
end
end