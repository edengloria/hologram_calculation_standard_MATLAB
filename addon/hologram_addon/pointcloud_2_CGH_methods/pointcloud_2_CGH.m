function complex_sum = pointcloud_2_CGH(point_array,d_view,filter,xx,yy,point_transfer_method,z_num)
%% 2020-06-25 ������ : ��� ����鿡�� ���Ի� ��Ͽ� ���� ��Ʈ�� �����Ͽ� ������ ���� -> upscailing method�� �� ȣȯ�� ���
%% 2020-10-07 ������ : Nx �� CPU_max_Nx*2 �� �ʰ��ϸ� complex_sum�� SSD�� ������    method7 
%%
t1=clock;
global lambda px py Nx Ny Ideal_angle_limit system_angle_limit k0 mm mpointer CPU_max_Nx;

filter = single(filter); k0 = single(k0);

if point_transfer_method == 1   
pointcloud_2_CGH_method1;        
%% 2�� ��� : x,y,z �ٻ��Ű��
elseif point_transfer_method == 2 %�� ���� ������ ���� ���� ��� - z���� ���̱ٻ� ���� 
pointcloud_2_CGH_method2; 
%% 3�� ��� : Ư�� plane �������� ������ �ٻ� �� FFT���� -> ���ڵ� ��Ŀ� threshold�� ���� ����� �ȳ���.
elseif point_transfer_method == 3 
pointcloud_2_CGH_method3; 
%% 2020/08/18 4�� ��� �ٷ� ���ļ� ���������� �ַ���� ���Ѵ�
elseif point_transfer_method == 4 % 2020/08/18 5���� �����ߴ�.  
pointcloud_2_CGH_method4; 
%% 5�� ���: 3�� ����� z������� ������ �ٻ��Ͽ� ����Ѵ�.
elseif point_transfer_method == 5 %�� ���� ������ ���� ���� ��� - z���� ���̱ٻ� ����
pointcloud_2_CGH_method5; 
%% 6�� ��� <- �˼� ���� ������ ū�������϶� ���ڸ������ ������ : ���, ������ ��
elseif point_transfer_method == 6 %�� ���� ������ ���� ���� ��� - z���� ���̱ٻ� ����
pointcloud_2_CGH_method6; 
%% 7�� ��� 2020/09/17 7�� ��� : 4�� ����� �����Ͽ� �ӵ� ���
elseif point_transfer_method == 7 %�� ���� ������ ���� ���� ��� - z���� ���̱ٻ� ����
pointcloud_2_CGH_method7;
%% [��Ʈ����] 2021/10 8�� ��� : 7�� ��Ŀ� RGB Intensity ���� �߰�
elseif point_transfer_method == 8 %�� ���� ������ ���� ���� ��� - z���� ���̱ٻ� ����
pointcloud_2_CGH_method8;

end

disp(['  "Point_cloud_calculation" calculation time : ' num2str(etime(clock,t1))]);
end




