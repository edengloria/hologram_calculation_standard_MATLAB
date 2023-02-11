    if (RGB_on)&(strcmp(reconstruct_type,'Fresnel')|strcmp(reconstruct_type,'DSF'))          
    px_color_ratio = double(px_recon./px_recon(active_color_num));  %최소픽셀 대비 픽셀 비율
    Reconstructed_GPU_temp = Reconstructed_GPU;
    for cnt = 1:active_color_num-1 
    map_t = imresize(Reconstructed_GPU_temp(:,:,cnt),px_color_ratio(cnt)); 
    range = ceil((size(map_t,1)-Ny)/2):ceil((size(map_t,1)-Ny)/2)+Ny-1;
    Reconstructed_GPU_temp(:,:,cnt) = map_t(range,range);  
    end 
    clear map_t;
%% 프레넬 전파를 활용하는 경우, 색분산을 보정하여 그림을 그려줌    
    figure(31);
    im = imagesc(Brightness_factor*rescale(abs(Reconstructed_GPU_temp))); caxis([0 3]); colormap gray; axis xy;
    im.Interpolation = 'bilinear';
    title('Color matched image for Fresnel propagation');
    xticks('');yticks('');set(gca,'LooseInset',get(gca,'TightInset'));
    end   
 %% 색분산 보정이 없는 그림 (ASM에서 주로 활용)
    figure(32);
%     set(gcf,'Visible','on'); % 이미지 해상도가 너무 크면 라이브 스크립트에서는 이 문구 추가해야 함
    imagesc(Brightness_factor*rescale(abs(Reconstructed_GPU))); caxis([0 3]); colormap gray; axis xy;
    xticks('');yticks('');set(gca,'LooseInset',get(gca,'TightInset'));
    title('Each color Reconstructed');
    if save_fig == 1
    imwrite(rescale(abs(Reconstructed_GPU)),'Reconstructed.bmp');
    end
 %%  특정 칼라만 선택해서 볼 수 있음
    if (RGB_on)&Mono_From_RGB
        
        if color_type == 'Red'
        reconstruct_color = 1;
        elseif color_type == 'Green'
        reconstruct_color = 2;
        elseif color_type == 'Blue'
        reconstruct_color = 3;
        end
    Reconstructed_GPU_Mono = zeros(Ny, Nx, 3);
    if RGB_on == 1
    Reconstructed_GPU_Mono(:,:,reconstruct_color) = Reconstructed_GPU(:,:,reconstruct_color);
    else
    selected_color = find_RGB(lambda_RGB,lambda_Mono);
    Reconstructed_GPU_Mono(:,:,selected_color) = Reconstructed_GPU;
    end
        
        
        figure(33);
        imagesc(Brightness_factor*rescale(abs(Reconstructed_GPU_Mono))); caxis([0 3]); colormap gray; axis xy;
        xticks('');yticks('');set(gca,'LooseInset',get(gca,'TightInset'));
        title('Selected color-only observation');
    end