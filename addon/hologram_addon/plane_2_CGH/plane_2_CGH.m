function complex_sum = plane_2_CGH(fmap,d_view,image_center_,xx,yy,propagation_type,random_phase_switch)
%% 2020-07-07 �����
%%
t1=clock;
global px py Nx Ny virtual_center DF_image_scale DF_intensity_scale Optimizer Iteration_num;
complex_sum = zeros(Ny,Nx,'single');
%% ���� ������ ���Ұ��ΰ�     
if random_phase_switch == 1
        fmap = fmap.*exp(j*2*pi*rand(size(fmap)));      
end
%% ����� ���� complex_sum ����
switch propagation_type
    case 'ASM'% ASM ���: ���� ���
        for im_cnt = 1:length(image_center_)                                      
        complex_sum = complex_sum + expanded_transfer_GPU_n(squeeze(fmap(:,:,im_cnt)), 2, 0, 0, 0, 0 ,-image_center_(im_cnt), 1, 1);        
        end             
    case 'Fresnel'% Fresnel approximation ���  % 2020-07-07 �ű�
        for im_cnt = 1:length(image_center_)
        
        if strcmp(Optimizer,"GS")   %% GS�˰��� ����� ����
        fmap_filter = abs(squeeze(fmap(:,:,im_cnt)));
        im_for_GS  = squeeze(fmap(:,:,im_cnt));
%         Iteration_num = 5;
        for GS_cnt = 1:Iteration_num
        GS_cnt  
        temp_field_GS = Fresnel_transfer_GPU(im_for_GS, xx, yy, 0, 0, -image_center_(im_cnt),'after',1);
        temp_field_GS = mean(abs(temp_field_GS),'all')*(temp_field_GS )./abs(temp_field_GS);
        temp_field_GS = Fresnel_transfer_GPU(temp_field_GS, xx, yy, 0, 0, image_center_(im_cnt),'before',1);
        im_for_GS = fmap_filter .* (temp_field_GS) ./ abs(temp_field_GS);
        end
        complex_sum = complex_sum + Fresnel_transfer_GPU(im_for_GS, xx, yy, 0, 0, -image_center_(im_cnt),'after',1);
        prepare_xx_yy_dfx_uu_vv;    %1���� �迭 ����, xx,yy,uu,vv,dfx ����

        else                            %% ���� ����
        complex_sum = complex_sum + Fresnel_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, 0, 0, -image_center_(im_cnt),'after',1);
        prepare_xx_yy_dfx_uu_vv;    %1���� �迭 ����, xx,yy,uu,vv,dfx ����
        end

        end 
    case 'ARSS'        
        for im_cnt = 1:length(image_center_)
        ARSS_scale = 1; % Ȧ�α׷� �̹��� Ȯ��   
        ARSS_offset_x = px*0;   ARSS_offset_y = px*0;  % Ȧ�α׷� �̹��� �̵�                                 
        complex_sum = complex_sum + ARSS_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, -image_center_(im_cnt),ARSS_scale,ARSS_offset_x,ARSS_offset_y);        
        end
    case 'DSF' 
        for im_cnt = 1:length(image_center_)           
%         complex_sum = complex_sum + Double_Fresnel_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, -virtual_center, -image_center_(im_cnt), Double_Fresnel_image_scale_(im_cnt));
        complex_sum = complex_sum + Double_Fresnel_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, -virtual_center, -image_center_(im_cnt), DF_image_scale(im_cnt))*DF_intensity_scale(im_cnt)^2;
        end
end



%% ���� ����Ÿ ��� (�þ�â ���)
% if strcmp(d_view,'off') == 0   % �þ�â ����϶��� ��� -> �þ�â ��� �ʹ� �����Ǽ� ���� �Ұ�
% distance_to_point = [0 0 d_view]; 
% phase_ref = k0*(sqrt(distance_to_point(3)^2+(x-distance_to_point(1)).^2+(y-distance_to_point(2)).^2)-distance_to_point(3)); 
% end
% %%
% for im_cnt = 1:length(image_center_)
%     if strcmp(propagation_type,'Fresnel Approximation')    % Fresnel approximation ���
% 
%     else    % ASM ���
%     complex_n = expanded_transfer_GPU_n(squeeze(fmap(:,:,im_cnt)), 2, 0, 0, 0, 0 ,-image_center_(im_cnt), 1, 1);
%     end
% 
%             if strcmp(d_view,'off') == 0
%             phase_n = angle(complex_n);
%             phase = -phase_n-phase_ref;
%             end   
%             %     phase = phase + phase_temp;
%             complex_temp(:,:,im_cnt) = complex_n;           
% end        
%         complex_sum = sum(complex_temp,3);