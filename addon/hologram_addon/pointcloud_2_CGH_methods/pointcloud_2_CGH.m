function complex_sum = pointcloud_2_CGH(point_array,d_view,filter,xx,yy,point_transfer_method,z_num)
%% 2020-06-25 변경점 : 모든 방법들에서 사입사 기록에 의한 파트를 제거하여 밖으로 뺐음 -> upscailing method와 의 호환성 고려
%% 2020-10-07 변경점 : Nx 가 CPU_max_Nx*2 를 초과하면 complex_sum을 SSD에 저장함    method7 
%%
t1=clock;
global lambda px py Nx Ny Ideal_angle_limit system_angle_limit k0 mm mpointer CPU_max_Nx;

filter = single(filter); k0 = single(k0);

if point_transfer_method == 1   
pointcloud_2_CGH_method1;        
%% 2번 방법 : x,y,z 근사시키기
elseif point_transfer_method == 2 %더 빠른 연산을 위해 묶어 계산 - z방향 깊이근사 적용 
pointcloud_2_CGH_method2; 
%% 3번 방법 : 특정 plane 기준으로 빠르게 근사 후 FFT진행 -> 인코딩 방식에 threshold가 들어가야 노이즈가 안낀다.
elseif point_transfer_method == 3 
pointcloud_2_CGH_method3; 
%% 2020/08/18 4번 방법 바로 주파수 도메인으로 솔루션을 구한다
elseif point_transfer_method == 4 % 2020/08/18 5번을 개선했다.  
pointcloud_2_CGH_method4; 
%% 5번 방법: 3번 방법에 z방향까지 점들을 근사하여 계산한다.
elseif point_transfer_method == 5 %더 빠른 연산을 위해 묶어 계산 - z방향 깊이근사 적용
pointcloud_2_CGH_method5; 
%% 6번 방법 <- 알수 없는 에러로 큰사이즈일때 격자모양으로 깨진다 : 폐기, 쓰지말 것
elseif point_transfer_method == 6 %더 빠른 연산을 위해 묶어 계산 - z방향 깊이근사 적용
pointcloud_2_CGH_method6; 
%% 7번 방법 2020/09/17 7번 방법 : 4번 방법을 개선하여 속도 향상
elseif point_transfer_method == 7 %더 빠른 연산을 위해 묶어 계산 - z방향 깊이근사 적용
pointcloud_2_CGH_method7;
%% [빛트코인] 2021/10 8번 방법 : 7번 방식에 RGB Intensity 정보 추가
elseif point_transfer_method == 8 %더 빠른 연산을 위해 묶어 계산 - z방향 깊이근사 적용
pointcloud_2_CGH_method8;

end

disp(['  "Point_cloud_calculation" calculation time : ' num2str(etime(clock,t1))]);
end




