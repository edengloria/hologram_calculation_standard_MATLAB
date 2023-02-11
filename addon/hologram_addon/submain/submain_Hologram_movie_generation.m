 %% 홀로그램 계산하기     
      image_center_ = image_center;  % 
if random_phase_switch == 1;  random_mask = exp(j*2*pi*rand(Ny, Nx)); % prepared random mask
elseif random_phase_switch == 0;  random_mask = ones(Ny,Nx); end; 
random_phase_switch = 0;

      ARSS_scale = 0;    ARSS_offset_x = 0;   ARSS_offset_y = 0;                   
   

if RGB_on == 1; complex_sum_color = zeros(Ny,Nx,length(lambda_)); end

v = VideoReader(object_root); % 동영상 파일명
numFrames = v.NumFrames;

switch calculation_type 
    case 'Fourier_plane'                 
for t = 1: numFrames
input_image =  padarray(read(v,t),[Ny/2-v.Height/2 Nx/2-v.Width/2]);  

for lm_cnt = 1:1:length(lambda_)
  lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle 정의, xx,yy,uu,vv,dfx 설정
  selected_color = find_RGB(lambda_RGB,lambda); 
  fmap = double(input_image(:,:,selected_color)).*random_mask;
  submain_Hologram_generation;
  
  if RGB_on == 1; complex_sum_color(:,:,lm_cnt) = complex_sum; end
end

  if RGB_on == 1; complex_sum = complex_sum_color; clear complex_sum_color; end
  
  if Part2(2)   % 0이면 No save와 동일함
filename = ['CGH_snap_' num2str(Filename_keyword) '_frame' num2str(t) '.jpg'];    
hologram_export(complex_sum,filename,sample_type,crop_size);
  end
  
end
end

%% 동영상 만들기
      video = VideoWriter(['CGH_movie_', num2str(Filename_keyword), '.mp4'],'MPEG-4'); video.Quality = 100; 
      % video = VideoWriter(['CGH_', num2str(Filename_keyword), '.avi'], 'Uncompressed AVI');
      video.FrameRate = movie_framerate;

      open(video);
      for t = 1: numFrames   
      filename = ['CGH_snap_' num2str(Filename_keyword) '_frame' num2str(t) '.jpg'];     
      frame = imread(filename);
      writeVideo(video, frame);    
      end
      close(video);  