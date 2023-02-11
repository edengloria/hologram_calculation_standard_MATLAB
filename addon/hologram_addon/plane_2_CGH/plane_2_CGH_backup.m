function complex_sum = plane_2_CGH(fmap,d_view,image_center_,xx,yy,propagation_type,random_phase_switch,virtual_center,Double_Frensel_image_scale)
%% 2020-07-07 �����
%%
t1=clock;
global lambda px py Nx Ny Ideal_angle_limit system_angle_limit k0 mm cm SLM_px SLM_py;

complex_sum = zeros(Ny,Nx,'single');
%% ���� ������ ���Ұ��ΰ�     
if random_phase_switch == 1
        fmap = fmap.*exp(j*2*pi*rand(size(fmap)));      
end
%% ����� ���� complex_sum ����
switch propagation_type
    case 'Angular Spectrum Method'% ASM ���: ���� ���
        for im_cnt = 1:length(image_center_)                                      
        complex_sum = complex_sum + expanded_transfer_GPU_n(squeeze(fmap(:,:,im_cnt)), 2, 0, 0, 0, 0 ,-image_center_(im_cnt), 1, 1);        
        end             
    case 'Fresnel Approximation'  % Fresnel approximation ���  % 2020-07-07 �ű�
        for im_cnt = 1:length(image_center_)
        complex_sum = complex_sum + Fresnel_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy,-image_center_(im_cnt),'after',1);
        prepare_xx_yy_dfx_uu_vv;    %1���� �迭 ����, xx,yy,uu,vv,dfx ����
        end 
    case 'ARSS Method'          
        for im_cnt = 1:length(image_center_)
        ARSS_scale = 1.5; % Ȧ�α׷� �̹��� Ȯ��   
        ARSS_offset_x = px*0;   ARSS_offset_y = px*0;  % Ȧ�α׷� �̹��� �̵�                                 
        complex_sum = complex_sum + ARSS_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, -image_center_(im_cnt),ARSS_scale,ARSS_offset_x,ARSS_offset_y);        
        end
    case 'Double-step Fresnel Diffraction'
        for im_cnt = 1:length(image_center_)           
        complex_sum = complex_sum + Double_Fresnel_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, -virtual_center, -image_center_(im_cnt), Double_Frensel_image_scale);
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