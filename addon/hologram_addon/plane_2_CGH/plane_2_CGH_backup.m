function complex_sum = plane_2_CGH(fmap,d_view,image_center_,xx,yy,propagation_type,random_phase_switch,virtual_center,Double_Frensel_image_scale)
%% 2020-07-07 만들다
%%
t1=clock;
global lambda px py Nx Ny Ideal_angle_limit system_angle_limit k0 mm cm SLM_px SLM_py;

complex_sum = zeros(Ny,Nx,'single');
%% 랜덤 페이즈 곱할것인가     
if random_phase_switch == 1
        fmap = fmap.*exp(j*2*pi*rand(size(fmap)));      
end
%% 방법에 따른 complex_sum 계산부
switch propagation_type
    case 'Angular Spectrum Method'% ASM 방식: 기존 방법
        for im_cnt = 1:length(image_center_)                                      
        complex_sum = complex_sum + expanded_transfer_GPU_n(squeeze(fmap(:,:,im_cnt)), 2, 0, 0, 0, 0 ,-image_center_(im_cnt), 1, 1);        
        end             
    case 'Fresnel Approximation'  % Fresnel approximation 방식  % 2020-07-07 신규
        for im_cnt = 1:length(image_center_)
        complex_sum = complex_sum + Fresnel_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy,-image_center_(im_cnt),'after',1);
        prepare_xx_yy_dfx_uu_vv;    %1차원 배열 마련, xx,yy,uu,vv,dfx 설정
        end 
    case 'ARSS Method'          
        for im_cnt = 1:length(image_center_)
        ARSS_scale = 1.5; % 홀로그램 이미지 확대   
        ARSS_offset_x = px*0;   ARSS_offset_y = px*0;  % 홀로그램 이미지 이동                                 
        complex_sum = complex_sum + ARSS_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, -image_center_(im_cnt),ARSS_scale,ARSS_offset_x,ARSS_offset_y);        
        end
    case 'Double-step Fresnel Diffraction'
        for im_cnt = 1:length(image_center_)           
        complex_sum = complex_sum + Double_Fresnel_transfer_GPU(squeeze(fmap(:,:,im_cnt)), xx, yy, -virtual_center, -image_center_(im_cnt), Double_Frensel_image_scale);
        end
end



%% 예전 데이타 백업 (시야창 방식)
% if strcmp(d_view,'off') == 0   % 시야창 방식일때만 사용 -> 시야창 방식 너무 오래되서 검증 불가
% distance_to_point = [0 0 d_view]; 
% phase_ref = k0*(sqrt(distance_to_point(3)^2+(x-distance_to_point(1)).^2+(y-distance_to_point(2)).^2)-distance_to_point(3)); 
% end
% %%
% for im_cnt = 1:length(image_center_)
%     if strcmp(propagation_type,'Fresnel Approximation')    % Fresnel approximation 방식
% 
%     else    % ASM 방식
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