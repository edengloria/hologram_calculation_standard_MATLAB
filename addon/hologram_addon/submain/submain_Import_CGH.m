%% CGH를 불러오는 경우


%% bmp 파일인 경우
if length(strfind(filename,'.bmp')) ~= 0 
    temp_data = exp(1j*2*pi*double(255-imread(filename))/256);
    complex_sum = padarray(temp_data,[Ny/2-size(temp_data,1)/2 Nx/2-size(temp_data,2)/2]);
%% mat(+bin) 파일인 경우
elseif length(strfind(filename,'.mat')) ~= 0 % 
    complex_sum = zeros(Ny,Nx,length(lambda_));
    
    for lm_cnt = 1:1:length(lambda_)
    filename_color =  [filename(1:end-5) num2str(lm_cnt)];   
    load([filename_color '.mat']);  %complex_sum 을 빼고 불러온다 % 2020/08/23
    if CPU_max_Nx*2 >= Nx
    fileID_r = fopen([filename_color '_real.bin'],'r'); fileID_i = fopen([filename_color '_imag.bin'],'r');
    complex_sum(:,:,lm_cnt) = fread(fileID_r,[Ny Nx],'single=>single') + 1j*fread(fileID_i,[Ny Nx],'single=>single');
    fclose(fileID_r); fclose(fileID_i);
    else
    complex_sum = 'not used';    
    end
    end
end