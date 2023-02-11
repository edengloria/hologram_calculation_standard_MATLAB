%% LF를 불러오는 경우

if length(strfind(filename,'.bmp')) ~= 0   % bmp 파일인 경우     
load([filename(1:end-4) '_supple.mat']);    % th_max, view_div_x,view_div_y, view_NN
LF_array = LF_array_2Dto4D(single(imread(filename)),view_div_x,view_div_y);   
LF_array = LF_array.*exp(1j*2*pi*rand(size(LF_array)));

elseif length(strfind(filename,'full.mat')) ~= 0 % mat(+bin) 파일인 경우
load(filename);    % LF_array, th_max, view_div_x,view_div_y, view_NN
end

%% Hogel based method
if strcmp(LF_calculation_type,'Hogel') 
% Light field to hologram
complex_sum = zeros(Ny,Nx,length(lambda_));

for lm_cnt = 1:1:length(lambda_)
lambda = lambda_(lm_cnt);    
complex_sum(:,:,lm_cnt) = Lightfield_to_CGH_4D(LF_array(:,:,:,:,lm_cnt), view_div_x, view_div_y, view_NN, th_max,Fixed_value_LF,px_LF(lm_cnt));
end
complex_sum = fftshift(ifft2(ifftshift(complex_sum)));

% Back propagation
if strcmp(propagation_type,'ASM')
for lm_cnt = 1:1:length(lambda_)
lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; 
complex_sum(:,:,lm_cnt) = expanded_transfer_GPU_n(complex_sum(:,:,lm_cnt), 2, 0, 0, 0, 0, -image_center, 1,1);
end
elseif strcmp(propagation_type, 'Fresnel')
for lm_cnt = 1:1:length(lambda_)
lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv;     
complex_sum(:,:,lm_cnt) = Fresnel_transfer_GPU(complex_sum(:,:,lm_cnt), xx, yy,-image_center,'after',1);
end
end

% 사입사를 맨 나중에 부여하자
if theta_ref ~= 0
     kx0 = single(k0*sind(theta_ref)*cosd(phi_ref));
     ky0 = single(k0*sind(theta_ref)*sind(phi_ref));
     phase_ref = -kx0*repmat(xx,size(yy.'))-ky0*repmat(yy.',size(xx));
     complex_sum(:,:,lm_cnt) = complex_sum(:,:,lm_cnt).*exp(-j*phase_ref); 
     clear phase_ref;
end
%% Non_hogel based method
elseif strcmp(LF_calculation_type,'Non_hogel') 
complex_sum = zeros(view_NN,view_NN,length(lambda_));

for lm_cnt = 1:1:length(lambda_)
lambda = lambda_(lm_cnt); 
complex_sum(:,:,lm_cnt) = Lightfield_to_CGH_nonhogel(LF_array(:,:,:,:,lm_cnt), view_div_x, view_div_y, view_NN, th_max,Fixed_value_LF);

end


end

