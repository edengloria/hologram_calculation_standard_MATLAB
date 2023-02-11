%% 포인트 클라우드 인 경우 데이타 형성 과정
% 1) 포인트 함수를 불러오거나, 만들어서 MATLAB내 배열로 얻어낸다.
% 2) 얻어진 포인트 배열을 축소/확대하고, 회전한다.
% 3) 중심 깊이만큼 떨어트린다.

%% 2022/06/07 메인코드 간소화를 위해 파장 루프를 여기다가 넣음
    for lm_cnt = 1:1:length(lambda_)
        if RGB_switch(lm_cnt)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle 정의, xx,yy,uu,vv,dfx 설정
        




%% 2021/05/17 메인코드 간소화를 위해 여기 삽입
f_lense_final = image_center/(1-magnification_factor); 

%% 1) 포인트 함수를 불러오거나, 만들어서 MATLAB내 배열로 얻어낸다.
if read_object_switch == 1                       
            if length(strfind(object_root,'.stl')) == 1 % stl 파일인 경우
                fv = stlread(object_root);  point_array_full=single((fv.vertices)'); %Read ".stl"
            elseif length(strfind(object_root,'.obj')) == 1 % obj 파일인 경우
                point_array_full=readObj(object_root)'; %Read ".obj"
            elseif length(strfind(object_root,'.mat')) == 1 % mat 파일인 경우 (point_array 불러오기 기능)
                
          %% [빛트코인]2021/10 Rhino ".txt" 파일로 저장했을 경우
            elseif length(strfind(object_root,'.txt')) == 1 % txt 파일인 경우
                point_array_full=flipud(rot90(readmatrix(object_root))); %Read ".txt"
                                
            elseif length(strfind(object_root,'.png')) == 1 % png 파일인 경우
                image_reduction_factor = 1; %그림 파일 받는 경우 image_reduction_factor는 적용하지 않는다.
                input_image=flipud(imread(object_root)); 
                input_image=input_image(:,:,1);   
                plane_width = Nx*px; plane_height= Ny*py;                 
                [y_place,x_place]=find(input_image~=0);
                point_x=zeros(1,length(x_place));   point_y=zeros(1,length(x_place));  point_z =zeros(1,length(x_place));                
                    for q = 1:length(x_place);
                        point_x(q)=xx(x_place(q));
                        point_y(q)=yy(y_place(q));           
                    end 
                point_array_full = [point_x;point_y;point_z];
            else    
                error(['object_root의 확장자가 올바르지 않습니다']);
            end      
                point_number_full=size(point_array_full,2);                 
                point_array = point_array_full(:,1:point_reduction_factor:end);
                point_number = size(point_array,2);
                clear point_array_full;              
elseif read_object_switch == 0 
        switch image_type
            case 'circle'  % 나선 생성
                radius = 1; point_number = 1001; depth = 5*radius; %반지름, 점의 개수, 총 깊이
                point_array = point_generation_circle(radius, point_number, depth);
                               
            case 'pyramid'  % 피라미드(밑면 정사각형) 생성
                length_ = 1;  height_ = 1.5;  % 피라미드 가로 세로
                bottom_number = 30;  side_number = 60;  % 옆면, 밑면의 점의 개수
                [point_array, point_number] = point_generation_pyramid(length_, height_, side_number, bottom_number);
                
            case 'cube' % 큐브 생성
                line_number = 50; % 각 선의 점의 개수
                L = 1;               % 각 선의 길이
                [point_array, point_number] = point_generation_cube(L, line_number);                   
        end
end
%% 2) 얻어진 포인트 배열을 축소/확대하고, 회전한다.                 
%% [빛트코인]2021/10 point_array x,y,z만 바뀌도록 수정
%               image_reduction_factor = 2*mm; % circle, pyramid, cube 추천                
                point_array(1:3,:) = image_reduction_factor*point_array(1:3,:);                        % 2) 포인트 배열 축소/확대.
                point_array(1:3,:) = point_array_rotation(point_array(1:3,:),rot_z,rot_x,rot_y);     % 포인트 회전변환, 함수 열어보면 추천값 있음      

%% 3) 중심 깊이만큼 떨어트린다.  
%                 image_center = 2*cm; 
                point_array(3,:) = single(point_array(3,:) + image_center);                      % 3) 중심 깊이만큼 떨어트린다.  
%% 배율보정                
                if magnification_factor ~= 1
                new_z  = -1./(1/f_lense_final- 1./point_array(3,:));    % z 보정
                new_mag = new_z./point_array(3,:);
                point_array(1,:) = new_mag.*point_array(1,:); point_array(2,:) = new_mag.*point_array(2,:);
                point_array(3,:) = new_z;              
                clear new_mag new_z;
%                 point_array(3,:) = z_reduction_factor*point_array(3,:);
                end
%%  2021/05/17 메인코드 간소화를 위해 여기 삽입              
                image_center = image_center/magnification_factor; 
                
                
        end
    end
                