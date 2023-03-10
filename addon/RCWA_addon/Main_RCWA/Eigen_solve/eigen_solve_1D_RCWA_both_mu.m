function [W Q X V inv_E] = eigen_solve_1D_RCWA_both_mu(E,A,M,B,alpha,K_x,ky,k0,layer_depth)


K_y=diag(repmat(ky,length(K_x),1));
% L=length(K_x);


% 반복되는 것은 미리 계산해둔다
I = eye(size(E));
inv_E = inv(E);
inv_A = inv(A);
inv_M = inv(M);
inv_B = inv(B);

inv_A_ = (1-alpha)*inv_A+alpha*E;
inv_E_ = (1-alpha)*inv_E+alpha*A;
% inv_E_ = inv_E;
% inv_A_ = inv_A;
% system 행렬을 만든다

SA  = [-K_x*inv_E_*K_y,K_x*inv_E_*K_x - M; -(K_y*inv_E_*K_y-inv_B),K_y*inv_E_*K_x];
% SA2 = K_x*inv_E*K_x - I;
% SB2 = inv_A; 
% SB = [inv_A,z;z,inv_A];

% eye of tiger 
SB  = [-K_x*inv_M*K_y,K_x*inv_M*K_x - E; -(K_y*inv_M*K_y-inv_A),K_y*inv_M*K_x];
% SB  = [-K_x*K_y,K_x*K_x - inv_A; -(K_y*K_y-inv_A),K_y*K_x];

% sumky = sum(sum(abs(SB(L+1:2*L,1:L))))

% SA  = [(K_x*inv_E*K_x - I)*inv_A,K_x*inv_E*K_y*inv_A; K_y*inv_E*K_x*inv_A,(K_y*inv_E*K_y-I)*inv_A];

temp = k0^2*SA*SB;% eigenvector 와 eigenvalue 를 구한다
% temp2 = temp(1:L,1:L);
% temp3 = k0^2*SA2*SB2;

% tempe = sum(sum(abs(temp2-temp3)))
% [W2 Q2] = eig(temp2);
[W Q] = eig(temp);
% Werror = sum(sum(abs(W-W2)))
% Qerror = sum(sum(abs(Q-Q2)))

Q = diag(Q);
Q = sqrt(Q);% eigenvalue 에 대한 것을 적절히 변환한다
% Q = -1*ones(1*L,  1);
n = size(Q);

for idx = 1 : n
    if real(Q(idx)) > 0    % 모든 값을 음수로 바꾼다
        Q(idx) = -Q(idx);
    end
end


% Q_temp = Q;
% W_temp = W;

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






