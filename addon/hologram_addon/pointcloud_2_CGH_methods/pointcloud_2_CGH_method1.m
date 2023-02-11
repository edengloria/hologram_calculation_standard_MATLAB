[x y] = meshgrid(xx,yy);
complex_sum = zeros(Ny,Nx,'single');
point_number = single(size(point_array,2));
if d_view == 'off' % 비 시야창 방식
%             phase_ref = -kx0*x-ky0*y;                     
            for p_cnt = 1:1:point_number  
                p_cnt
              phase  = k0*( (x-point_array(1,p_cnt)).^2/2/point_array(3,p_cnt) + (y-point_array(2,p_cnt)).^2/2/point_array(3,p_cnt))+2*pi*rand;
              amplitude = 1/point_array(3,p_cnt);
              amplitude_filtered = amplitude.*((x-point_array(1,p_cnt)).^2+(y-point_array(2,p_cnt)).^2<=filter^2*point_array(3,p_cnt)^2/k0^2);   
              complex_sum = complex_sum + amplitude_filtered.*exp(j*(phase));   
            end
             
else % 시야창 방식 사입사 미구현
            point_VW = [0 0 d_view];  
            for p_cnt = 1:1:point_number
                p_cnt
              new_z  = point_VW(3)*point_array(3,p_cnt)/(point_VW(3) -point_array(3,p_cnt));
              new_x  = (point_VW(3)*point_array(1,p_cnt)-point_VW(1)*point_array(3,p_cnt))/(point_VW(3) -point_array(3,p_cnt));
              new_y  = (point_VW(3)*point_array(2,p_cnt)-point_VW(2)*point_array(3,p_cnt))/(point_VW(3) -point_array(3,p_cnt));             
              phase  = k0*( (x-new_x).^2/2/new_z + (y-new_y).^2/2/new_z)+2*pi*rand; % d_view가 off 가 아닌 경우
              
              amplitude = 1/point_array(3,p_cnt);
              amplitude_filtered = amplitude.*((x-new_x).^2+(y-new_y).^2<=filter^2*new_z^2/k0^2);   
              complex_sum = complex_sum + amplitude_filtered.*exp(j*phase);
                      end
end