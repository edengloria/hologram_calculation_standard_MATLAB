function matrix_out = folded_toeplitz_1D_new(vector_in)
% toeplitz ����� �����. MATLAB ���� �����ϴ� toeplitz �ʹ� �ణ �ٸ���
% [1 2 3 4 5] �� vector �� ������
% 
% 3 2 1
% 4 3 2  
% 5 4 3
% 
% �̷� ����� �����

%% 2022-01-14 ���� %%
% [1 2 3 4 5] �� vector �� ������
len = length(vector_in);  
r = flip(vector_in(1:(len+1)/2));  % [3 2 1] 
c = vector_in((len+1)/2:end);    % [3 4 5] 
matrix_out = toeplitz(c,r);       % ���� �����


%% 2022-01-14 ����
% ���̰� Ȧ�� ���� Ȯ��
% len = length(vector_in);
% if mod(len, 2) == 0
%     error(['length is not odd']);
% end;
% 
% % ����� ����
% c = ceil( len / 2);  % len �� 5 �̸�, c �� 3 �� �ȴ�
% matrix_out = zeros(c, c);
% 
% for idx = 1 : c
%     matrix_out(:,idx) = vector_in(c-idx+1:2*c-idx);
% end

% sum(sum(abs(matrix_out2 - matrix_out)))
end

% clear len c idx;




