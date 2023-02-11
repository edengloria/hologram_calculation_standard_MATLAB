function point_array = point_generation_circle(radius, point_number, depth);

        theta = linspace (2*pi/point_number,2*pi,point_number);
 
        point_x = radius*cos(theta);
        point_y = radius*sin(theta);
%         point_z = zeros(size(point_x))+image_center;
        point_z = depth/2*linspace(-1,1,point_number);
        
        point_array = [point_x;point_y;point_z];     