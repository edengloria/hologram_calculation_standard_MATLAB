function new_CGH_FFT = Lightfield_to_CGH_4D(LF_array, view_div_x, view_div_y, view_NN, th_max, Fixed_value_LF, px_LF);
%% 2021/05/12 변경점 : 2D form 이 아닌 4D form으로 출력 -> non-hogel 방식 대비
global Ny Nx lambda;

dfx = 1/px_LF/Nx; dfy = 1/px_LF/Ny;        % 주파수 도메인 벡터 생성

new_uu = dfx*[-Nx/2-view_NN/2+1:Nx/2+view_NN/2];

        if strcmp(Fixed_value_LF, 'theta_max') % RGB 관측 각도 통일 (색수차 없음)                 
        uv_min = -sind(th_max)/lambda;      % 한계 각도가 가장 작은 파장 기준으로 통일
        [dummy u_start] =min(abs(new_uu-uv_min));
        u_center = ceil(linspace(1+u_start, Nx+view_NN-u_start , view_div_x));
        v_center = u_center ;
        elseif strcmp(Fixed_value_LF, 'uv_max') % uv_domain에서 통일 (Non-hogel 구현을 위함)
        duv = 1/px_LF/view_div_x;    jump_uv = round(duv/dfx); 
        u_center = (length(new_uu)-jump_uv*(view_div_x-1))/2 + [1:jump_uv:1+jump_uv*(view_div_x-1)]; 
        v_center = u_center ;
        end

LF_array = ifftshift(fft2(fftshift((LF_array))));  
new_CGH_FFT = zeros([Ny+view_NN Nx+view_NN]);

 for  anx_cnt = 1:length(u_center)
     for any_cnt = 1:length(v_center)
       
       temp_range = -view_NN/2+1:1:view_NN/2;
       new_CGH_FFT(v_center(any_cnt)+temp_range,u_center(anx_cnt)+temp_range) =  new_CGH_FFT(v_center(any_cnt)+temp_range,u_center(anx_cnt)+temp_range) + LF_array(:,:,any_cnt,anx_cnt);
       
%         figure(1)
%         imagesc(abs(new_CGH));
    end
end

new_CGH_FFT = new_CGH_FFT(view_NN/2+1:view_NN/2+Ny, view_NN/2+1:view_NN/2+Nx);

%%  기존 방법 2D 인풋
%  for  anx_cnt = 1:length(u_center)
%      for any_cnt = 1:length(v_center)

         
%        y_range = (any_cnt-1)*view_NN +1 : (any_cnt)*view_NN;
%        x_range = (anx_cnt-1)*view_NN +1 : (anx_cnt)*view_NN;
%        
% %        y_range = (length(v_center)-any_cnt)*view_NN +1 : (length(v_center)-any_cnt+1)*view_NN;
% %        x_range = (length(u_center)-anx_cnt)*view_NN +1 : (length(u_center)-anx_cnt+1)*view_NN;
%        
%        LF_array_small =  LF_array(y_range,x_range);
%        LF_array_small = ifftshift(fft2(fftshift((LF_array_small)))); 
% %        LF_array_small = fftshift(ifft2(ifftshift((LF_array_small))));
%        
%        temp_range = -view_NN/2+1:1:view_NN/2;
%        new_CGH_FFT(v_center(any_cnt)+temp_range,u_center(anx_cnt)+temp_range) =  new_CGH_FFT(v_center(any_cnt)+temp_range,u_center(anx_cnt)+temp_range) + LF_array_small;
%        
% %        figure(1)
% %        imagesc(abs(new_CGH));
%     end
% end


end