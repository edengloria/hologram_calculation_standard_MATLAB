%% 2022/06/07 �����ڵ� ����ȭ�� ���� ���� ������ ����ٰ� ����
fmap = zeros([Ny Nx length(lambda_) length(image_center_)]);  

for lm_cnt = 1:1:length(lambda_)
        if RGB_switch(lm_cnt)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle ����, xx,yy,uu,vv,dfx ����
        



%% 2021/7/13 ���� ����, mono �϶�, multi image �ȵǴ°� ����
        f_lense_final = image_center_/(1-magnification_factor);
%         image_reduction_factor = 1; point_reduction_factor = 0;
        plane_number = length(image_center_); % ǥ�� plane �� ����

        
        for im_cnt = 1:plane_number

           if strcmp(Part1, 'Calculate_movie_CGH');
            input_image= input_image_(:,:,:,im_cnt); %�̹����� �ѹ� �� �Ʒ� ����� �޾ƾ� ����    
           else
            input_image= flipud(imread(object_root(im_cnt))); %�̹����� �ѹ� �� �Ʒ� ����� �޾ƾ� ���� 
           end
           
%% �̹��� ������ �ȸ����� ����
    if (image_ratio_size(1) ~= size(input_image,1)) | (image_ratio_size(2) ~= size(input_image,2))
            disp('Input image size is not matched to Nx');
            input_image = imresize(input_image,[image_ratio_size(1) image_ratio_size(2)]);
            input_image = padarray(input_image,[ceil((Ny-size(input_image,1))/2)   ceil((Nx-size(input_image,2))/2) ]);
    end
%% Į�� �̹����� ���    
    if (size(input_image,3) ~= 1) && (RGB_on == 1) %% Į�� �̹����� ���
            active_color = find(RGB_switch); active_color_num= active_color(end);
        if strcmp(propagation_type,'Fresnel')
            input_image=imresize(input_image(:,:,lm_cnt),lambda_(active_color_num)/lambda); % RGB �̹��� ����
            y_range = 1:size(input_image,1)-mod(size(input_image,1),2);
            x_range = 1:size(input_image,2)-mod(size(input_image,2),2);
            input_image = padarray(input_image(y_range,x_range),[ceil((Ny-size(input_image,1))/2)   ceil((Nx-size(input_image,2))/2) ]);
        else
            selected_color = find_RGB(lambda_RGB,lambda);
            input_image=input_image(:,:,selected_color);  
        end
        fmap(:,:,lm_cnt,im_cnt) = fmap(:,:,lm_cnt,im_cnt) + single(input_image);
    else


%%  Mono �̹����� ��� 
        fmap(:,:,1,im_cnt) = fmap(:,:,1,im_cnt) + single(input_image(:,:,1));    
     end   
%         figure(1)
%         imagesc(fmap(:,:,1)); axis xy;
        end
        %%
  image_center_ = image_center_/magnification_factor;
        end
    end