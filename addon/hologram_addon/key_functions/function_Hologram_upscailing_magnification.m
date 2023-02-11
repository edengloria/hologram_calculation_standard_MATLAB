function complex_sum_out = function_Hologram_upscailing_magnification(magnification_factor,complex_sum,xx,yy,f_lense_final,more_division_num);
%% 2020-07-14/ More division num �� ���� ���� ����� �� ����� ������ �ذ� �����ϳ�, ���� ������ ���ڰ����� ����
%%
global nm um mm cm lambda k0 px py Nx Ny Ideal_angle_limit system_angle_limit;

if magnification_factor == 1
    complex_sum_out = complex_sum;
else
   complex_sum_backup = complex_sum;  
   complex_sum_out = zeros(size(complex_sum)*magnification_factor,'single');

shift_x_ = linspace(-Nx*px*magnification_factor/2,Nx*px*magnification_factor/2,magnification_factor*more_division_num);
shift_x_ = shift_x_ - linspace(-Nx*px*magnification_factor/2+Nx*px/2,Nx*px*magnification_factor/2-Nx*px/2,magnification_factor*more_division_num);
shift_y_ = shift_x_;

[x, y] = meshgrid(xx,yy);

if more_division_num ~= 1
filter_frequency = 1.2*sqrt(2)*xx(end)/more_division_num;
%  filter_function =  abs(xx)<filter_frequency;
 filter_function =  1./(1+exp(-15*(filter_frequency-abs(sqrt(x.^2+y.^2)))/filter_frequency));
% figure(55); imagesc(filter_function);
end


 for  x_cnt = 1:magnification_factor*more_division_num
disp(['       Upscailing : ' num2str(x_cnt) '/' num2str(magnification_factor*more_division_num)]); %�־��� Ȧ�α׷� ���� ����� ���ؼ� �ʿ��� �ִ� ���� ������ �˷��ش�. 
     for y_cnt = 1:magnification_factor*more_division_num
%         for  x_cnt = 8
%     for y_cnt = 8
shift_x = shift_x_(x_cnt);   shift_y = shift_y_(y_cnt);
if more_division_num == 1
complex_temp = complex_sum_backup.*exp(j*pi*((x-shift_x).^2 + (y-shift_y).^2)/lambda/f_lense_final); %���� Ȯ���Ŵ magnification_factor��ŭ
else
complex_temp = filter_function.*complex_sum_backup.*exp(j*pi*((x-shift_x).^2 + (y-shift_y).^2)/lambda/f_lense_final);
end
%% �߶�ֱ� ver
% y_range_temp =  Ny/2 - Ny/2/more_division_num + 1 :  Ny/2 + Ny/2/more_division_num; 
% x_range_temp =  Nx/2 - Nx/2/more_division_num + 1 :  Nx/2 + Nx/2/more_division_num; 
% 
% y_range = Ny/more_division_num*(y_cnt-1)+1:Ny/more_division_num*y_cnt;  
% x_range = Nx/more_division_num*(x_cnt-1)+1:Nx/more_division_num*x_cnt;  
% 
% complex_sum_out(y_range,x_range) = complex_temp(y_range_temp,x_range_temp);  
%% �����ֱ� ver
% ���ϴ� ���� �߰���ǥ
y_pix_center = Ny/more_division_num*(y_cnt-1/2)+1;
x_pix_center = Nx/more_division_num*(x_cnt-1/2)+1;

% �������� �� �ȿ� ��ġ �ȼ� �� ����
y_pix_edge = [max(y_pix_center-Ny/2,1) min(y_pix_center+Ny/2-1,Ny*magnification_factor)];
x_pix_edge = [max(x_pix_center-Nx/2,1) min(x_pix_center+Nx/2-1,Nx*magnification_factor)];

% �������� �ʰ��Ǿ �߷������� �ȼ���
y_pix_cut  = [max(1 - (y_pix_center-Ny/2), 0)  max(y_pix_center+Ny/2-1 - Ny*magnification_factor,0)];  
x_pix_cut  = [max(1 - (x_pix_center-Nx/2), 0)  max(x_pix_center+Nx/2-1 - Nx*magnification_factor,0)];  

complex_sum_out(y_pix_edge(1):1:y_pix_edge(2),x_pix_edge(1):1:x_pix_edge(2)) = complex_sum_out(y_pix_edge(1):1:y_pix_edge(2),x_pix_edge(1):1:x_pix_edge(2)) + complex_temp(1+y_pix_cut(1):end-y_pix_cut(end),1+x_pix_cut(1):end-x_pix_cut(end));  
    end
end

%  figure(111)
%  imagesc(abs(complex_sum_out));axis xy;daspect([1 1 1]);
end
