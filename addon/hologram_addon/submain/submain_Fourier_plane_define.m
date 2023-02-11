%% 2022/06/07 메인코드 간소화를 위해 파장 루프를 여기다가 넣음
fmap = zeros([Ny Nx length(lambda_) length(image_center_)]);  

for lm_cnt = 1:1:length(lambda_)
        if RGB_switch(lm_cnt)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle 정의, xx,yy,uu,vv,dfx 설정
        



%% 2021/7/13 오류 수정, mono 일때, multi image 안되는것 수정
        f_lense_final = image_center_/(1-magnification_factor);
%         image_reduction_factor = 1; point_reduction_factor = 0;
        plane_number = length(image_center_); % 표시 plane 의 개수

        
        for im_cnt = 1:plane_number

           if strcmp(Part1, 'Calculate_movie_CGH');
            input_image= input_image_(:,:,:,im_cnt); %이미지를 한번 위 아래 뒤집어서 받아야 정상    
           else
            input_image= flipud(imread(object_root(im_cnt))); %이미지를 한번 위 아래 뒤집어서 받아야 정상 
           end
           
%% 이미지 사이즈 안맞으면 보정
    if (image_ratio_size(1) ~= size(input_image,1)) | (image_ratio_size(2) ~= size(input_image,2))
            disp('Input image size is not matched to Nx');
            input_image = imresize(input_image,[image_ratio_size(1) image_ratio_size(2)]);
            input_image = padarray(input_image,[ceil((Ny-size(input_image,1))/2)   ceil((Nx-size(input_image,2))/2) ]);
    end
%% 칼라 이미지인 경우    
    if (size(input_image,3) ~= 1) && (RGB_on == 1) %% 칼라 이미지인 경우
            active_color = find(RGB_switch); active_color_num= active_color(end);
        if strcmp(propagation_type,'Fresnel')
            input_image=imresize(input_image(:,:,lm_cnt),lambda_(active_color_num)/lambda); % RGB 이미지 수정
            y_range = 1:size(input_image,1)-mod(size(input_image,1),2);
            x_range = 1:size(input_image,2)-mod(size(input_image,2),2);
            input_image = padarray(input_image(y_range,x_range),[ceil((Ny-size(input_image,1))/2)   ceil((Nx-size(input_image,2))/2) ]);
        else
            selected_color = find_RGB(lambda_RGB,lambda);
            input_image=input_image(:,:,selected_color);  
        end
        fmap(:,:,lm_cnt,im_cnt) = fmap(:,:,lm_cnt,im_cnt) + single(input_image);
    else


%%  Mono 이미지인 경우 
        fmap(:,:,1,im_cnt) = fmap(:,:,1,im_cnt) + single(input_image(:,:,1));    
     end   
%         figure(1)
%         imagesc(fmap(:,:,1)); axis xy;
        end
        %%
  image_center_ = image_center_/magnification_factor;
        end
    end