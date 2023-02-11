    t2=clock; % 재생 파트 시간 계산
%%  reconstruct_type 설정
if strcmp(reconstruct_type, 'Same as Part1')
reconstruct_type = propagation_type;
    if strcmp(propagation_type, 'ARSS')
    reconstruct_type = 'ASM';    
    end
end


 Reconstructed_GPU = zeros(size(CGH_pattern));  

%% 2022/05 재생 파트 파장 루프 안으로 넣음  
    for lm_cnt = 1:1:length(lambda_)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle 정의, xx,yy,uu,vv,dfx 설정

switch reconstruct_type
    case 'ASM'
    Reconstructed_GPU(:,:,lm_cnt) = expanded_transfer_GPU_n(CGH_pattern(:,:,lm_cnt), 2, theta_recon, phi_recon, 0, 0, reconstructed_distance, 1,1);
    case 'Fresnel'
    [Reconstructed_GPU(:,:,lm_cnt) px_recon(lm_cnt) py_recon(lm_cnt)] = Fresnel_transfer_GPU(CGH_pattern(:,:,lm_cnt),xx, yy, theta_recon, phi_recon, reconstructed_distance,'before',1);
    case 'DSF'
%% Multi-focus 고려한 방식 (Fresnel 후 Fresnel)
 
            [temp new_px new_py] = Fresnel_transfer_GPU(CGH_pattern(:,:,lm_cnt), xx, yy, 0, 0, virtual_center, 'before',1);
            new_xx = (linspace(-new_px*Nx/2+new_px/2,+new_px*Nx/2-new_px/2,Nx)); 
            new_yy = (linspace(-new_py*Ny/2+new_py/2,+new_py*Ny/2-new_py/2,Ny));
            [new_x, new_y] = meshgrid(new_xx,new_yy);

            filter_map = zeros(size(new_x));

            for cnt = 1: length(focus_center_x)
            filter_map = filter_map|((new_x - focus_center_x(cnt)).^2 + (new_y - focus_center_y(cnt)).^2  < filter_diameter.^2/4);
            end
            
            if lm_cnt == 1 % 빨강만 대표로 그려봄
            figure(lm_cnt); colormap red_laser;    
            imagesc(30*rescale(abs(temp))+0.1*abs(filter_map)); caxis([0 1]); axis xy; 
            end

            temp = temp.*filter_map; 
            temp2 = Fresnel_transfer_GPU(temp, xx, yy, 0, 0, -virtual_center, 'after',1);
            [Reconstructed_GPU(:,:,lm_cnt) px_recon(lm_cnt) py_recon(lm_cnt)]  = Fresnel_transfer_GPU(temp2, xx, yy, 0, 0, reconstructed_distance, 'before',1);
        
%% 2022/05 이전 방식 백업 (ASM 후 Fresnel)        
%     temp = expanded_transfer_GPU_n(CGH_pattern(:,:,lm_cnt), 2, theta_recon, phi_recon, 0, 0, virtual_center, 1,1);
%     temp2 = temp .*(repmat(xx,size(yy.')).^2 + repmat(yy.',size(xx)).^2 < filter_diameter^2/4);
%     if lm_cnt == 1
%     figure(lm_cnt); colormap red_laser;
%     imagesc(abs(temp)+1*abs(temp2)); caxis([0 1]); axis xy; 
%     elseif lm_cnt == 2
%     figure(lm_cnt); colormap green_laser;
%     imagesc(abs(temp)+1*abs(temp2)); caxis([0 1]); axis xy; 
%     elseif lm_cnt == 3
%     figure(lm_cnt); colormap blue_laser;
%     imagesc(abs(temp)+1*abs(temp2)); caxis([0 1]); axis xy; 
%     end
%    [Reconstructed_GPU(:,:,lm_cnt) px_recon(lm_cnt) py_recon(lm_cnt)]  = Fresnel_transfer_GPU(temp2, xx, yy, 0, 0, reconstructed_distance-virtual_center, 'before',1);
end
    end
    
    %%
        disp(['  "Part3: Reconstruct image plane" calculation time : ' num2str(etime(clock,t2))]);
