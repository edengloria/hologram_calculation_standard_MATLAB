function out_data = point_array_rotation(in_data,rot_z,rot_x,rot_y)
% pyramid 추천값:   rot_x = 4*pi/10; rot_y = 2*pi/10; rot_z = 8*pi/10; 
% cube 추천값:   rot_x = pi/4; rot_y = pi/3; rot_z = 0; 
% 시우 SL 구조물 : rot_x =  -pi/2; rot_y = 0; rot_z = 0; 
% 2020-04-22 rad-> degree  수정
rot_mat_z = [cosd(rot_z) -sind(rot_z) 0;
             sind(rot_z) cosd(rot_z)  0;  
                0           0       1;];
rot_mat_x = [ 1 0 0;
               0 cosd(rot_x) -sind(rot_x);  
               0  sind(rot_x) cosd(rot_x);];
rot_mat_y = [ cosd(rot_y) 0 sind(rot_y);
               0           1      0 ;  
               -sind(rot_y) 0 cosd(rot_y);];

out_data = rot_mat_z*rot_mat_x*rot_mat_y*in_data;