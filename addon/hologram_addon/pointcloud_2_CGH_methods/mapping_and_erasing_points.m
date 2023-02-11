function [x_p, y_p, z_p] = mapping_and_erasing_points(xx,yy,zz,point_array,point_number,z_num)
global px py Nx Ny;
%% 2020/09/17 mapping and erasing 속도 대폭 향상
%% mapping
t2 = clock;
% for p_cnt = 1:1:point_number
%     [dumy, x_p(p_cnt)]=min(abs(xx-point_array(1,p_cnt)));
%     
%     [dumy, y_p(p_cnt)]=min(abs(yy-point_array(2,p_cnt)));
%     [dumy, z_p(p_cnt)]=min(abs(zz-point_array(3,p_cnt)));
% end

x_p = min(max(round((point_array(1,:)- xx(1))/px + 1),1),Nx);
y_p = min(max(round((point_array(2,:)- yy(1))/py + 1),1),Ny);
if z_num > 1
dzz = zz(2) - zz(1);
z_p = min(max(round((point_array(3,:)- zz(1))/dzz + 1),1),z_num);
else
z_p = ones([1 point_number]);
end

%% erasing
xyz_p = [x_p; y_p; z_p;]'; point_before = length(x_p); 
xyz_p  = unique(xyz_p,'rows'); 
x_p = xyz_p(:,1)'; y_p = xyz_p(:,2)'; z_p = xyz_p(:,3)';  point_after = length(x_p);
disp(['  "Duplicated point erasing" from ', num2str(point_before) ,' to ', num2str(point_after) '      time: ', num2str(etime(clock,t2))]);
%%
% xyz_p = [x_p; y_p; z_p;];
% p_array = []; p_cnt = 1; checked_array = zeros(size(x_p));
% 
% 
% for p_cnt = 1:1: point_number
% if checked_array(p_cnt) == 0
% p_array = [p_array p_cnt];
% aaa = find(~sum(abs(xyz_p-[x_p(p_cnt); y_p(p_cnt); z_p(p_cnt);]),1));
% checked_array(aaa) = 1; 
% end
% end
% 
% x_p = x_p(p_array); y_p = y_p(p_array); z_p = z_p(p_array);

end