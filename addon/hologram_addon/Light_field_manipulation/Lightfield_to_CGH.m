function new_CGH_FFT = Lightfield_to_CGH(LF_array, u_center, v_center, view_NN);
%% 2021/05/12 변경점 : 2D form 이 아닌 4D form으로 출력 -> non-hogel 방식 대비
global Ny Nx;

% LF_array2 = reshape(LF_array,[view_NN view_NN length(v_center) length(u_center)]);

% LF_array2 = ifftshift(fft2(fftshift((LF_array2))));  

new_CGH_FFT = zeros([Ny Nx]);
for  anx_cnt = 1:length(u_center)
    for any_cnt = 1:length(v_center)
       y_range = (any_cnt-1)*view_NN +1 : (any_cnt)*view_NN;
       x_range = (anx_cnt-1)*view_NN +1 : (anx_cnt)*view_NN;
       
%        y_range = (length(v_center)-any_cnt)*view_NN +1 : (length(v_center)-any_cnt+1)*view_NN;
%        x_range = (length(u_center)-anx_cnt)*view_NN +1 : (length(u_center)-anx_cnt+1)*view_NN;
       
       LF_array_small =  LF_array(y_range,x_range);
       LF_array_small = ifftshift(fft2(fftshift((LF_array_small)))); 
%        LF_array_small = fftshift(ifft2(ifftshift((LF_array_small))));
       
       temp_range = -view_NN/2+1:1:view_NN/2;
       new_CGH_FFT(v_center(any_cnt)+temp_range,u_center(anx_cnt)+temp_range) =  new_CGH_FFT(v_center(any_cnt)+temp_range,u_center(anx_cnt)+temp_range) + LF_array_small;
       
%        figure(1)
%        imagesc(abs(new_CGH));
    end
end


end