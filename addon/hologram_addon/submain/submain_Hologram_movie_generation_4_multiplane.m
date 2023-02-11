 %% 홀로그램 계산하기     

image_center_org = image_center_;  % 
if random_phase_switch == 1;  random_mask = exp(j*2*pi*rand(Ny, Nx)); % prepared random mask
elseif random_phase_switch == 0;  random_mask = ones(Ny,Nx); end; 

random_phase_switch = 0;
% ARSS_scale = 0;    ARSS_offset_x = 0;   ARSS_offset_y = 0;                   
   

v1 = VideoReader(object_root(1)); % 동영상 파일명
v2 = VideoReader(object_root(2)); % 동영상 파일명

numFrames = v2.NumFrames;

if All_frames == 1;  Cal_frames  = [1:numFrames]; end; 
    
complex_sum_movie = zeros(Ny,Nx,length(lambda_),length(Cal_frames));
input_image_ =zeros(Ny,Nx,length(lambda_),length(image_center_));      
 
for t = 1: length(Cal_frames)
        frame_num = Cal_frames(t)
    
if RGB_on == 1; complex_sum_color = zeros(Ny,Nx,length(lambda_)); end

input_image_(:,:,:,1) =  padarray(read(v1,frame_num),[Ny/2-v1.Height/2 Nx/2-v1.Width/2]);
input_image_(:,:,:,2) =  padarray(read(v2,frame_num),[Ny/2-v2.Height/2 Nx/2-v2.Width/2]);

submain_Fourier_plane_define;
fmap = fmap.*random_mask;
  
for lm_cnt = 1:1:length(lambda_)
        if RGB_switch(lm_cnt)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle 정의, xx,yy,uu,vv,dfx 설정
        submain_Hologram_generation;
       if RGB_on == 1; complex_sum_color(:,:,lm_cnt) = complex_sum; end
       end    
end

if RGB_on == 1; complex_sum = complex_sum_color; clear complex_sum_color; end
  
if Part2(2)   % 0이면 No save와 동일함
filename = ['CGH_snap_' num2str(Filename_keyword) '_frame' num2str(frame_num) '.jpg'];    
hologram_export(complex_sum,filename,sample_type,crop_size);
end
  
complex_sum_movie(:,:,:,t) = complex_sum;
end


%% CGH 동영상 만들기
      video = VideoWriter(['CGH_movie_', num2str(Filename_keyword), '.mp4'],'MPEG-4'); video.Quality = 100; 
      % video = VideoWriter(['CGH_', num2str(Filename_keyword), '.avi'], 'Uncompressed AVI');
      video.FrameRate = movie_framerate;

      open(video);
for t = 1: length(Cal_frames)
        frame_num = Cal_frames(t);
        
      filename = ['CGH_snap_' num2str(Filename_keyword) '_frame' num2str(frame_num) '.jpg'];     
      frame = imread(filename);
      writeVideo(video, frame);    
      end
      close(video);  