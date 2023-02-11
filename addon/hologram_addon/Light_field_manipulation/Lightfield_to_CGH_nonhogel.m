function new_CGH = Lightfield_to_CGH_nonhogel(LF_array, view_div_x, view_div_y, view_NN, th_max , Fixed_value_LF);
%% 2021/05/18 non-hogel 방식 구현해보자
global Ny Nx px py lambda;


prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle 정의, xx,yy,uu,vv,dfx 설정
new_uu = dfx*[-Nx/2-view_NN/2+1:Nx/2+view_NN/2];

        if strcmp(Fixed_value_LF, 'theta_max') % RGB 관측 각도 통일 (색수차 없음)                 
        error('Non-hogel LF calculation is not working for Fixed_value_LF = "theta_max" condition!');
        elseif strcmp(Fixed_value_LF, 'non_hogel') % uv_domain에서 통일 (Non-hogel 구현을 위함)
         duv = (view_NN/Nx)/px/view_div_x;    jump_uv = round(duv/dfx); 
        u_center = (length(new_uu)-jump_uv*(view_div_x-1))/2 + [1:jump_uv:1+jump_uv*(view_div_x-1)]; 
        v_center = u_center ;
        end

LF_array_ = shiftdim(LF_array,2);  % [y x v u] -> [v u y x] 로 이동
LF_array_bar = ifftshift(fft2(fftshift((LF_array_))));  % [v u] 도메인에 대한 FFT 수행
LF_array_bar = shiftdim(LF_array_bar,2);  % [v u y x] -> [y x v u] 로 이동
new_CGH= sum(sum(LF_array_bar,3),4);
 
 
 
 
%  figure(1)
%  imagesc(abs(LF_array(:,:,1,15)));        
% 
%  figure(2)
%  imagesc(abs(LF_array(:,:,15,15)));   
 
% du_b = mean(uu(u_center_(2:end))-uu(u_center_(1:end-1)));
% dtau_b = 1/view_div_x/du_b;

% 

%  LF_array_2D = LF_array_4Dto2D(LF_array);
 

% LF_array_bar_2D = LF_array_4Dto2D(LF_array_bar);



 figure(3)
 imagesc(abs(new_CGH));
 
% LF_array_shifted_sum_rand= sum(sum(LF_array_bar*exp(j*2*pi*rand(1)),3)*exp(j*2*pi*rand(1)),4);
% figure(6)
% imagesc(angle(LF_array_shifted_sum));
% 
% 
% LF_array_shifted = zeros(size(LF_array_bar));
% 
% for vcnt = 1: view_div_y
% for ucnt = 1: view_div_x
%    v_shift =  vcnt-view_div_y/2;  u_shift =  ucnt-view_div_x/2;   
% if (v_shift >= 0) && (u_shift >= 0)
% LF_array_shifted(1+floor(v_shift/2):end,1+floor(u_shift/2):end,vcnt, ucnt) = LF_array_bar(1:end-floor(v_shift/2) ,1:end-floor(u_shift/2) ,vcnt, ucnt);
% elseif (v_shift < 0) && (u_shift >= 0)
% LF_array_shifted(1:end+floor(v_shift/2),1+floor(u_shift/2):end,vcnt, ucnt) = LF_array_bar(1-floor(v_shift/2):end ,1:end-floor(u_shift/2) ,vcnt, ucnt);    
% elseif (v_shift >= 0) && (u_shift < 0)
% LF_array_shifted(1+floor(v_shift/2):end,1:end+floor(u_shift/2),vcnt, ucnt) = LF_array_bar(1:end-floor(v_shift/2) ,1-floor(u_shift/2):end ,vcnt, ucnt);    
% else  (v_shift < 0) && (u_shift < 0)
% LF_array_shifted(1:end+floor(v_shift/2),1:end+floor(u_shift/2),vcnt, ucnt) = LF_array_bar(1-floor(v_shift/2):end ,1-floor(u_shift/2):end ,vcnt, ucnt);    
% end
% 
% end
% end
% 
% figure(3)
% imagesc(abs(LF_array_shifted(:,:,1,1)));
% 
% LF_array_shifted_sum= sum(sum(LF_array_bar,3),4);
% 
% figure(4)
% imagesc(abs(LF_array_shifted_sum));
end