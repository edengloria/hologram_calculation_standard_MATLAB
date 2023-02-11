function Reconstructed_GPU_FFT = Prepare_FFT_of_Part3(Reconstructed_GPU,theta_recon,phi_recon);

global Nx Ny px py Part3 lambda_;

Reconstructed_GPU_FFT = zeros(Ny,Nx,length(lambda_));
for lm_cnt = 1:1:length(lambda_)
lambda = lambda_(lm_cnt);
prepare_lambda_k0_xx_yy_dfx_uu_vv;    %labmda,k0,ideal_angle_limit, xx,yy,uu,vv,dfx 설정

% switch eye_view_type 
%      case 'conventional'  
% submain_eye_view_calculation_conventional; %eye_view 구버전, 사장될 듯 하여 따로 정리 view_NN이 1인 경우 로 합칠까?   
%     case 'super_fast' 

if Part3(1) == 1 
Reconstructed_GPU_FFT(:,:,lm_cnt) = ifftshift(fft2(fftshift(Reconstructed_GPU(:,:,lm_cnt)))); %% FFT된 Reconstructed_GPU
elseif Part3(1) == 0 
    if theta_recon ~= 0      
    kx_recon = single(k0*sind(theta_recon)*cosd(phi_recon));
    ky_recon = single(k0*sind(theta_recon)*sind(phi_recon));
    phase_recon = kx_recon*repmat(xx,size(yy.'))+ky_recon*repmat(yy.',size(xx));
    Reconstructed_GPU =  Reconstructed_GPU.*exp(-j*phase_recon);   
    end 
%     if strcmp(CGH_pattern,'not used') == 1  %% CPU_RAM이 저장을 감당 못할 경우 SSD에 분할하여 읽고 쓰고 한다.
%     filename_in =  'CGH_pattern';   filename_out = 'Reconstructed_GPU_FFT';
%     Function_2DFFT_CPUover(filename_in,filename_out);     
%     Reconstructed_GPU_FFT = 'not used';  %%  대용량 칼라는 미구현
%     else
    Reconstructed_GPU_FFT(:,:,lm_cnt) = ifftshift(fft2(fftshift(Reconstructed_GPU(:,:,lm_cnt)))); %% FFT된 CGH_pattern
%     end
end
end