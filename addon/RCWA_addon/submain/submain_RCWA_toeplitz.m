Ep_toep_layer =zeros(L,L,layer_type_num);
Ap_toep_layer =zeros(L,L,layer_type_num);

Ep_toep_layer2 =zeros(L,L,layer_type_num);
Ap_toep_layer2 =zeros(L,L,layer_type_num);
% Bp_toep_layer =zeros(L,L,layer_type_num);

for cnt=1:layer_type_num
if Dimension     == '2D' 
t12=clock;
Ep_toep_layer(:,:,cnt)        = folded_toeplitz_1D(Epg_layer(:,:,cnt));
Ap_toep_layer(:,:,cnt)        = folded_toeplitz_1D(Apg_layer(:,:,cnt));
disp(['       done.  elapsed time : ' num2str(etime(clock,t12))]); 

% Bp_toep_layer(:,:,cnt)        = folded_toeplitz_1D(Bpg_layer(:,:,cnt));
elseif Dimension     == '3D' 
Ep_toep_layer(:,:,cnt)        = folded_toeplitz_2D(Epg_layer(:,:,cnt));   
Ap_toep_layer(:,:,cnt)        = folded_toeplitz_2D(Apg_layer(:,:,cnt));
end
end