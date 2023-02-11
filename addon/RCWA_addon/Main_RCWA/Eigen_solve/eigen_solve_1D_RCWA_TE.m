function [W Q X V inv_E] = eigen_solve_1D_RCWA_TE(E,A,alpha,K_x,k0,layer_depth)





% 반복되는 것은 미리 계산해둔다
I = eye(size(E));
inv_E = inv(E);
inv_A = inv(A);



% system 행렬을 만든다
%TM
% SA = K_x*inv_E*K_x - I;
% 
% SB = inv_A;
%TE
SA = I;
SB = K_x*K_x - E;

temp = k0^2*SA*SB;% eigenvector 와 eigenvalue 를 구한다
[W Q] = eig(temp);

Q = diag(Q);
Q = sqrt(Q);% eigenvalue 에 대한 것을 적절히 변환한다
% Q = -1*ones(1*L,  1);
n = size(Q);

for idx = 1 : n
    if real(Q(idx)) > 0    % 모든 값을 음수로 바꾼다
        Q(idx) = -Q(idx);
    end
end


[dont_use sort_index] = sort(imag(Q),'descend');
for idx = 1 : n
    Q_temp(idx,1)   = Q(sort_index(idx),1);
    W_temp(:,idx)   = W(:,sort_index(idx));
end

% Power normalization; 1 (W/Gambda) 
V_temp = inv(k0*SA)*W_temp*diag(Q_temp);
% for idx = 1 : n
%     power           = 1/2*(real(sum(W_temp(:,idx).*conj(j*V_temp(:,idx)))));
%     W_temp(:,idx)   = W_temp(:,idx)/sqrt(power);
%     V_temp(:,idx)   = V_temp(:,idx)/sqrt(power);
% end

Q = Q_temp;
W = W_temp;
X = exp(Q*layer_depth);
V = V_temp;






