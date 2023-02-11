function [point_array,point_number] = point_generation_pyramid(length_, height, side_line_point_number, bottom_line_point_number);

        l = length_;
        h= height;
        temp_z = linspace(-h/2, h/2, side_line_point_number);
        temp_xy = linspace(l/2, 0, side_line_point_number);
        
        point_x=[];
        point_y=[];
        point_z=[];
       for q = 1:side_line_point_number
           if q == 1 % bottom
               for qq = 1:4*(bottom_line_point_number-1), point_z=[point_z temp_z(q)]; end
               dl = l/(bottom_line_point_number-1);
               point_x=[point_x linspace(-l/2,l/2,bottom_line_point_number) linspace(-l/2,l/2,bottom_line_point_number)];
               point_x=[point_x -l/2*ones(1, bottom_line_point_number-2) l/2*ones(1, bottom_line_point_number-2)];
               point_y=[point_y -l/2*ones(1, bottom_line_point_number) l/2*ones(1, bottom_line_point_number)];
               point_y=[point_y linspace(-l/2+dl,l/2-dl,bottom_line_point_number-2) linspace(-l/2+dl,l/2-dl,bottom_line_point_number-2)];
           elseif q == side_line_point_number %top
                point_z=[point_z temp_z(q)];
                point_x=[point_x 0];
                point_y=[point_y 0];
           else  %middle
                for qq = 1:4, point_z=[point_z temp_z(q)]; end
               point_x=[point_x temp_xy(q) temp_xy(q) -temp_xy(q) -temp_xy(q)];
               point_y=[point_y temp_xy(q) -temp_xy(q) temp_xy(q) -temp_xy(q)];
           end
       end
      point_number=length(point_z);
      point_array = [point_x;point_y;point_z];