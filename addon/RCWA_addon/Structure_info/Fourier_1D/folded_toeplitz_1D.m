function matrix_out = folded_toeplitz_1D_new(vector_in)
% toeplitz 행렬을 만든다. MATLAB 에서 제공하는 toeplitz 와는 약간 다르다
% [1 2 3 4 5] 인 vector 를 받으면
% 
% 3 2 1
% 4 3 2  
% 5 4 3
% 
% 이런 행렬을 만든다

%% 2022-01-14 이후 %%
% [1 2 3 4 5] 인 vector 를 받으면
len = length(vector_in);  
r = flip(vector_in(1:(len+1)/2));  % [3 2 1] 
c = vector_in((len+1)/2:end);    % [3 4 5] 
matrix_out = toeplitz(c,r);       % 동일 결과임


%% 2022-01-14 이전
% 길이가 홀수 인지 확인
% len = length(vector_in);
% if mod(len, 2) == 0
%     error(['length is not odd']);
% end;
% 
% % 행렬을 만듦
% c = ceil( len / 2);  % len 이 5 이면, c 는 3 이 된다
% matrix_out = zeros(c, c);
% 
% for idx = 1 : c
%     matrix_out(:,idx) = vector_in(c-idx+1:2*c-idx);
% end

% sum(sum(abs(matrix_out2 - matrix_out)))
end

% clear len c idx;




