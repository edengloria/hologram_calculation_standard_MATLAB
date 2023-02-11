for lm_cnt = 1:1:length(lambda_)
        if RGB_switch(lm_cnt)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle ����, xx,yy,uu,vv,dfx ����
        


%% 2021/7/13 ���� ����, mono �϶�, multi image �ȵǴ°� ����

        f_lense_final = image_center_/(1-magnification_factor);

        image_reduction_factor = 1; point_reduction_factor = 0;
        plane_number = length(image_center_); % ǥ�� plane �� ����
        fmap = zeros([length(yy) length(xx) length(image_center_)]);        
        for im_cnt = 1:plane_number
%             image_center = image_center_(im_cnt);
%             input_image= imread(object_root(im_cnt)); 
            input_image= flipud(input_image_(:,:,:,im_cnt)); %�̹����� �ѹ� �� �Ʒ� ����� �޾ƾ� ���� 

%             imagesc(input_image);
            %% �̹��� ������ �ȸ����� ����
    if (image_ratio_size(1) ~= size(input_image,1)) | (image_ratio_size(2) ~= size(input_image,2))
            disp('Input image size is not matched to Nx');
            input_image = imresize(input_image,[image_ratio_size(1) image_ratio_size(2)]);
            input_image = padarray(input_image,[ceil((Ny-size(input_image,1))/2)   ceil((Nx-size(input_image,2))/2) ]);
    end
%% Į�� �̹����� ���    
    if (size(input_image,3) ~= 1) & (exist('lambda_'))  %% Į�� �̹����� ���
        if strcmp(propagation_type,'Fresnel Approximation')
%             input_image=input_image(:,:,lm_cnt);  % RB ������ ����
            input_image=imresize(input_image(:,:,lm_cnt),lambda_(end)/lambda); % RGB �̹��� ����
            y_range = 1:size(input_image,1)-mod(size(input_image,1),2);
            x_range = 1:size(input_image,2)-mod(size(input_image,2),2);
            input_image = padarray(input_image(y_range,x_range),[ceil((Ny-size(input_image,1))/2)   ceil((Nx-size(input_image,2))/2) ]);
        else
            selected_color = find_RGB(lambda_RGB,lambda);
            input_image=input_image(:,:,selected_color);  
        end
        fmap(:,:,im_cnt) = fmap(:,:,im_cnt) + single(input_image);
    else


%%  Mono �̹����� ��� 
        fmap(:,:,im_cnt) = fmap(:,:,im_cnt) + single(input_image(:,:,1));    
     end   
%         figure(1)
%         imagesc(fmap(:,:,1)); axis xy;
        end
        %%
  image_center_ = image_center_/magnification_factor;
        end
end
