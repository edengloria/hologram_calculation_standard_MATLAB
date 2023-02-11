%% [빛트코인]2021/10 RGB Intenstiy 정보가 있는 mapping 방법
function [x_p, y_p, z_p, I_p] = mapping_and_erasing_points_2(xx,yy,zz,point_array,point_number,z_num)
global lm_cnt px py Nx Ny;
t2 = clock;

x_p = min(max(round((point_array(1,:)- xx(1))/px + 1),1),Nx);
y_p = min(max(round((point_array(2,:)- yy(1))/py + 1),1),Ny);
if z_num > 1
dzz = zz(2) - zz(1);
z_p = min(max(round((point_array(3,:)- zz(1))/dzz + 1),1),z_num); 
else
z_p = ones([1 point_number]);
end
I_p = point_array(lm_cnt+3,:);

% %% erasing 
% xyzI_p = [x_p; y_p; z_p; I_p]'; point_before = length(x_p); 
% xyzI_p = unique(xyzI_p,'rows');  
% x_p = xyzI_p(:,1)'; y_p = xyzI_p(:,2)'; z_p = xyzI_p(:,3)'; I_p = xyzI_p(:,4)';  point_after = length(x_p);
% disp(['  "Duplicated point erasing" from ', num2str(point_before) ,' to ', num2str(point_after) '      time: ', num2str(etime(clock,t2))]);


%% erasing + Intensity 가 0인 점들은 아예 삭제
xyzI_p = [x_p; y_p; z_p; I_p]'; point_before = length(x_p); 
xyzI_p = unique(xyzI_p,'rows');  I_p_temp = xyzI_p(:,4);
x_p = xyzI_p(I_p_temp~=0,1)'; y_p = xyzI_p(I_p_temp~=0,2)'; z_p = xyzI_p(I_p_temp~=0,3)'; I_p = xyzI_p(I_p_temp~=0,4)';  point_after = length(x_p);
disp(['  "Duplicated point erasing" from ', num2str(point_before) ,' to ', num2str(point_after) '      time: ', num2str(etime(clock,t2))]);

end