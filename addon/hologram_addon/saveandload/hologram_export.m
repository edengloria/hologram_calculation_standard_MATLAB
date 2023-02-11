function hologram_export(complex_sum,filename,sample_type,crop_size)
global Nx Ny filename_load RGB_on;

y_range = (size(complex_sum,1)-crop_size(1))/2 + [1:crop_size(1)];   
x_range = (size(complex_sum,2)-crop_size(2))/2 + [1:crop_size(2)]; 

if Ny*Nx >  (2^32-1)
    division_list = [2 4 10 20 40 100 200 400 800];
%     division_num = ceil(size(complex_sum,1)*size(complex_sum,2)/2^32);
    division_num = ceil(Ny*Nx/2^28);
    division_num = division_list(find(division_list >= division_num,1));
else
    division_num = 1;
end


if strcmp(complex_sum,'not used') == 1
%% 초대형 CGH
switch sample_type 
    case 'No_save'        
    case 'binary_encoding'
if division_num == 1
    pattern = uint8((real(bin_read(filename_load,[Ny,Nx],[Ny,Nx],[1 1]))>0)*255);
    imwrite_for_hologram_export(pattern(y_range,x_range,:),RGB_on,filename);      
else
    div_col = Ny/division_num;
    for cnt = 1:1:division_num
%     range = (cnt-1)*div_col+1:1:cnt*div_col;
%     temp = bin_read(filename_load,[Ny,Nx],[div_col,Nx],[(cnt-1)*div_col+1 1]);
    pattern = uint8((real(   bin_read(filename_load,[Ny,Nx],[div_col,Nx],[(cnt-1)*div_col+1 1])   )>0)*255);
    filename_sub = ['Div' num2str(cnt) '_' filename];    
    imwrite_for_hologram_export(pattern(y_range,x_range,:),RGB_on,filename_sub);
%     imwrite(pattern,filename_sub);
    
    
    end
end    
    case '256_phase' 
qu_level = 256;
if division_num == 1
    pattern = uint8(wrapTo2Pi(angle(bin_read(filename_load,[Ny,Nx],[Ny,Nx],[1 1])))/2/pi*255.99);
    imwrite_for_hologram_export(255-pattern(y_range,x_range,:),RGB_on,filename);
    
else
    div_col = Ny/division_num;
    for cnt = 1:1:division_num
%     range = (cnt-1)*div_col+1:1:cnt*div_col;
    pattern = uint8(wrapTo2Pi(angle(  bin_read(filename_load,[Ny,Nx],[div_col,Nx],[(cnt-1)*div_col+1 1])  ))/2/pi*255.99);
    filename_sub = ['Div' num2str(cnt) '_' filename];
    %     imwrite(pattern,filename_sub); % 미반전
%     imwrite(255-pattern,filename_sub); % 제이랩 반전
    imwrite_for_hologram_export(255-pattern,RGB_on,filename_sub);
    
    end
end     
end
else
%% 기존분할
switch sample_type 
    case 'No_save'   
   
    case 'binary_encoding'
if division_num == 1
    pattern = uint8((real(complex_sum)>0)*255);
    
%     imwrite(pattern(y_range,x_range,:),filename);
    imwrite_for_hologram_export(pattern(y_range,x_range,:),RGB_on,filename);
   
else
    div_col = size(complex_sum,1)/division_num;
    for cnt = 1:1:division_num
    range = (cnt-1)*div_col+1:1:cnt*div_col;
    pattern = uint8((real(complex_sum(range,:))>0)*255);
    filename_sub = ['Div' num2str(cnt) '_' filename];
    
%     imwrite(pattern,filename_sub);
    imwrite_for_hologram_export(pattern,RGB_on,filename_sub);
    
    end
end
%%
    case '32_phase'

qu_level = 32;
if division_num == 1
    pattern = (256/qu_level)*uint8(wrapTo2Pi(angle(complex_sum))/2/pi*(qu_level-0.5));
%     imwrite(pattern,filename); % 미반전
%     imwrite(255-pattern(y_range,x_range,:),filename); % 제이랩 반전
    imwrite_for_hologram_export(255-pattern(y_range,x_range,:),RGB_on,filename);
      
else
    div_col = size(complex_sum,1)/division_num;
    for cnt = 1:1:division_num
    range = (cnt-1)*div_col+1:1:cnt*div_col;
    pattern = (256/qu_level)*uint8(wrapTo2Pi(angle(complex_sum(range,:)))/2/pi*(qu_level-0.5));
    filename_sub = ['Div' num2str(cnt) '_' filename];
    %     imwrite(pattern,filename_sub); % 미반전
%     imwrite(255-pattern,filename_sub); % 제이랩 반전
    imwrite_for_hologram_export(255-pattern,RGB_on,filename_sub);
    
    end
end        
        
        

%%   
    case '256_phase' 
qu_level = 256;
if division_num == 1
    pattern = uint8(wrapTo2Pi(angle(complex_sum))/2/pi*255.99);
%     imwrite(pattern,filename); % 미반전
%     imwrite(255-pattern(y_range,x_range,:),filename); % 제이랩 반전
    imwrite_for_hologram_export(255-pattern(y_range,x_range,:),RGB_on,filename);
      
else
    div_col = size(complex_sum,1)/division_num;
    for cnt = 1:1:division_num
    range = (cnt-1)*div_col+1:1:cnt*div_col;
    pattern = uint8(wrapTo2Pi(angle(complex_sum(range,:)))/2/pi*255.99);
    filename_sub = ['Div' num2str(cnt) '_' filename];
    %     imwrite(pattern,filename_sub); % 미반전
%     imwrite(255-pattern,filename_sub); % 제이랩 반전
    imwrite_for_hologram_export(255-pattern,RGB_on,filename_sub);
    
    end
end

    case 'double_phase'
        amp_ratio = acos(abs(complex_sum)./max(max(abs(complex_sum))));
        phase_cond = angle(complex_sum);
        
        phase1 = phase_cond+amp_ratio;
        phase2 = phase_cond-amp_ratio;
        scaling_factor = 2;
        M = (checkerboard(scaling_factor,Ny/(2*scaling_factor),Nx/(2*scaling_factor)) > 0.5);
        phase = phase1.*(~M)+phase2.*M;        
        
        pattern = uint8(wrapTo2Pi(phase)/2/pi*255.99);
        imwrite_for_hologram_export(255-pattern(y_range,x_range,:),RGB_on,filename);
end
%%
end

end