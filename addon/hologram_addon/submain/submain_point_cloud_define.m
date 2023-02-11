%% ����Ʈ Ŭ���� �� ��� ����Ÿ ���� ����
% 1) ����Ʈ �Լ��� �ҷ����ų�, ���� MATLAB�� �迭�� ����.
% 2) ����� ����Ʈ �迭�� ���/Ȯ���ϰ�, ȸ���Ѵ�.
% 3) �߽� ���̸�ŭ ����Ʈ����.

%% 2022/06/07 �����ڵ� ����ȭ�� ���� ���� ������ ����ٰ� ����
    for lm_cnt = 1:1:length(lambda_)
        if RGB_switch(lm_cnt)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle ����, xx,yy,uu,vv,dfx ����
        




%% 2021/05/17 �����ڵ� ����ȭ�� ���� ���� ����
f_lense_final = image_center/(1-magnification_factor); 

%% 1) ����Ʈ �Լ��� �ҷ����ų�, ���� MATLAB�� �迭�� ����.
if read_object_switch == 1                       
            if length(strfind(object_root,'.stl')) == 1 % stl ������ ���
                fv = stlread(object_root);  point_array_full=single((fv.vertices)'); %Read ".stl"
            elseif length(strfind(object_root,'.obj')) == 1 % obj ������ ���
                point_array_full=readObj(object_root)'; %Read ".obj"
            elseif length(strfind(object_root,'.mat')) == 1 % mat ������ ��� (point_array �ҷ����� ���)
                
          %% [��Ʈ����]2021/10 Rhino ".txt" ���Ϸ� �������� ���
            elseif length(strfind(object_root,'.txt')) == 1 % txt ������ ���
                point_array_full=flipud(rot90(readmatrix(object_root))); %Read ".txt"
                                
            elseif length(strfind(object_root,'.png')) == 1 % png ������ ���
                image_reduction_factor = 1; %�׸� ���� �޴� ��� image_reduction_factor�� �������� �ʴ´�.
                input_image=flipud(imread(object_root)); 
                input_image=input_image(:,:,1);   
                plane_width = Nx*px; plane_height= Ny*py;                 
                [y_place,x_place]=find(input_image~=0);
                point_x=zeros(1,length(x_place));   point_y=zeros(1,length(x_place));  point_z =zeros(1,length(x_place));                
                    for q = 1:length(x_place);
                        point_x(q)=xx(x_place(q));
                        point_y(q)=yy(y_place(q));           
                    end 
                point_array_full = [point_x;point_y;point_z];
            else    
                error(['object_root�� Ȯ���ڰ� �ùٸ��� �ʽ��ϴ�']);
            end      
                point_number_full=size(point_array_full,2);                 
                point_array = point_array_full(:,1:point_reduction_factor:end);
                point_number = size(point_array,2);
                clear point_array_full;              
elseif read_object_switch == 0 
        switch image_type
            case 'circle'  % ���� ����
                radius = 1; point_number = 1001; depth = 5*radius; %������, ���� ����, �� ����
                point_array = point_generation_circle(radius, point_number, depth);
                               
            case 'pyramid'  % �Ƕ�̵�(�ظ� ���簢��) ����
                length_ = 1;  height_ = 1.5;  % �Ƕ�̵� ���� ����
                bottom_number = 30;  side_number = 60;  % ����, �ظ��� ���� ����
                [point_array, point_number] = point_generation_pyramid(length_, height_, side_number, bottom_number);
                
            case 'cube' % ť�� ����
                line_number = 50; % �� ���� ���� ����
                L = 1;               % �� ���� ����
                [point_array, point_number] = point_generation_cube(L, line_number);                   
        end
end
%% 2) ����� ����Ʈ �迭�� ���/Ȯ���ϰ�, ȸ���Ѵ�.                 
%% [��Ʈ����]2021/10 point_array x,y,z�� �ٲ�� ����
%               image_reduction_factor = 2*mm; % circle, pyramid, cube ��õ                
                point_array(1:3,:) = image_reduction_factor*point_array(1:3,:);                        % 2) ����Ʈ �迭 ���/Ȯ��.
                point_array(1:3,:) = point_array_rotation(point_array(1:3,:),rot_z,rot_x,rot_y);     % ����Ʈ ȸ����ȯ, �Լ� ����� ��õ�� ����      

%% 3) �߽� ���̸�ŭ ����Ʈ����.  
%                 image_center = 2*cm; 
                point_array(3,:) = single(point_array(3,:) + image_center);                      % 3) �߽� ���̸�ŭ ����Ʈ����.  
%% ��������                
                if magnification_factor ~= 1
                new_z  = -1./(1/f_lense_final- 1./point_array(3,:));    % z ����
                new_mag = new_z./point_array(3,:);
                point_array(1,:) = new_mag.*point_array(1,:); point_array(2,:) = new_mag.*point_array(2,:);
                point_array(3,:) = new_z;              
                clear new_mag new_z;
%                 point_array(3,:) = z_reduction_factor*point_array(3,:);
                end
%%  2021/05/17 �����ڵ� ����ȭ�� ���� ���� ����              
                image_center = image_center/magnification_factor; 
                
                
        end
    end
                