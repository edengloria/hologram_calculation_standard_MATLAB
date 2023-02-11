function [LF_array th_max] = Light_field_calculation_4D(Reconstructed_GPU_FFT, view_NN,  view_div_x, view_div_y, Fixed_value_LF,px_recon);
%% 2021/05/12 ������ : orthogonal view ����
%% 2021/05/12 ������ : 2D form �� �ƴ� 4D form���� ��� -> non-hogel ��� ���
%% 2021/05/18 ������ : �ΰ��� ���� (���� ���� vs uv����) ���� �����ϰ� ���� 
%% �Է°��� �����е� �߰� 

global Part3 Nx Ny lambda_;

th_max = asind(min(lambda_./px_recon)/2)*0.95; % Ideal_angle_limits

LF_array = zeros(view_NN,view_NN,view_div_y,view_div_x,length(lambda_));
% [xxx yyy] = meshgrid(-view_NN/2+1:1:view_NN/2,-view_NN/2+1:1:view_NN/2);
% filter_circle = ((xxx.^2 + yyy.^2) < (view_NN/2).^2);


Reconstructed_GPU_FFT = padarray(Reconstructed_GPU_FFT,[view_NN/2 view_NN/2]);

for lm_cnt = 1:1:length(lambda_)
    px_LF = px_recon(lm_cnt);    
    
        lambda = lambda_(lm_cnt); 

%         k0 = 2*pi/lambda;          % ���� ����, �������ļ� ����
%         Ideal_angle_limit = asind(lambda/px_LF/2)- 0.0001; % limit angle ����

%         xx = (linspace(-px_LF*Nx/2,+px_LF*Nx/2,Nx)); % ���� ������ ���� ����
%         yy = (linspace(-px_LF*Ny/2,+px_LF*Ny/2,Ny)); % -px_LF*Ny/2,+px_LF*Ny/2 ���̿� Ny����ŭ ����
        dfx = 1/px_LF/Nx; % dfy = 1/px_LF/Ny;        % ���ļ� ������ ���� ����
%         uu = (dfx*[-Nx/2+1:Nx/2]); % sin_thx= 2*pi*uu/k0; 
%         vv = (dfy*[-Ny/2+1:Ny/2]);

% sin_thx= 2*pi*uu/k0; 
% sin_thy= 2*pi*vv/k0; 
        new_uu = dfx*[-Nx/2-view_NN/2+1:Nx/2+view_NN/2];
        
        if strcmp(Fixed_value_LF, 'theta_max') % RGB ���� ���� ���� (������ ����)                 
        uv_min = -sind(th_max)/lambda;      % �Ѱ� ������ ���� ���� ���� �������� ����
        [dummy u_start] =min(abs(new_uu-uv_min));
        u_center_ = ceil(linspace(1+u_start, Nx+view_NN-u_start , view_div_x));
        v_center_ = u_center_ ;
        elseif strcmp(Fixed_value_LF, 'uv_max') % uv_domain���� ���� (Non-hogel ������ ����)
        duv = 1/px_LF/view_div_x;    jump_uv = round(duv/dfx); 
        u_center_ = (length(new_uu)-jump_uv*(view_div_x-1))/2 + [1:jump_uv:1+jump_uv*(view_div_x-1)]; 
        v_center_ = u_center_ ;
        elseif strcmp(Fixed_value_LF, 'non_hogel') % uv_domain���� ���� (Non-hogel ������ ����)
        duv = (view_NN/Nx)/px_LF/view_div_x;    jump_uv = round(duv/dfx); 
        u_center_ = (length(new_uu)-jump_uv*(view_div_x-1))/2 + [1:jump_uv:1+jump_uv*(view_div_x-1)]; 
        v_center_ = u_center_ ;
        end

%% ���������� �߽����� ã�´� - �ִ� ȸ���� ��������
LF_array_4D = zeros(view_NN,view_NN,view_div_y,view_div_x);

for u_center_cnt = 1:length(u_center_)
    for v_center_cnt = 1:length(v_center_)  
thx_center = u_center_(u_center_cnt);   thy_center = v_center_(v_center_cnt);
%% �߽����� �������� FFT����Ÿ �Ϻ� ����  
LF_array_4D(:,:,v_center_cnt,u_center_cnt) = Reconstructed_GPU_FFT(thy_center-view_NN/2+1:1:thy_center+view_NN/2,thx_center-view_NN/2+1:1:thx_center+view_NN/2, lm_cnt);
    end
end
% LF_array_4D = LF_array_4D.*filter_circle;
 LF_array(:,:,:,:,lm_cnt) = fftshift(ifft2(ifftshift((LF_array_4D))));
end

end
