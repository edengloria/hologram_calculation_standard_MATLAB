function [Cgp_f Cgn_i] = enhanced_T_at_first_boundary_col_new(F_f,G_f,W_i,X_i,V_i,k0,Cgp_i)

% NOTE
%       2008.01.20 JHPARK
%                   X_input = ones(L,1) 이어야 한다.
[L2 L2] = size(F_f);

jk0V_i = j*k0*V_i;
% XCgp_i = X_i.*Cgp_i;
XCgp_i = Cgp_i;

%% previous
% t11=clock;
% temp = inv([F_f, -W_i;G_f,  jk0V_i]) * [W_i*XCgp_i;jk0V_i*XCgp_i];
% disp(['       done.  elapsed time : ' num2str(etime(clock,t11))]);   

%% new
t12=clock;
temp = [F_f, -W_i;G_f,  jk0V_i] \ [W_i*XCgp_i;jk0V_i*XCgp_i];
% disp(['       done.  elapsed time : ' num2str(etime(clock,t12))]); 

% sum(sum(temp))
% error2 = sum(sum(temp-temp2))
%%
Cgp_f = temp(0*L2+1:1*L2,:);
Cgn_i = temp(1*L2+1:2*L2,:);

% A = F_f; clear F_f;
% B = -W_i; clear W_i;
% C = G_f; clear G_f;
% D = jk0V_i; clear jk0V_i;
% 
% I_ = eye(size(A));
% ta = (I_-(B)*inv(D)*C*inv(A));
% tb = (I_-(C)*inv(A)*B*inv(D));
% Cgp_f = inv(ta*(A))*((-B)*XCgp_i)  -  inv(A)*B*inv(D)*inv(tb)*(D*XCgp_i) ;
% Cgn_i = -inv(D)*C*inv(A)*inv(ta)*((-B)*XCgp_i)  +  inv(tb*D)* (D*XCgp_i) ;
% ta = (I_-(B/D)*(C/A));
% tb = (I_-(C/A)*(B/D));
% Cgp_f = (ta*(A))\((-B)*XCgp_i)  -  inv(A)*B*inv(tb*D)*(D*XCgp_i) ;
% Cgn_i = -inv(D)*C*inv(ta*A)*((-B)*XCgp_i)  +  (tb*D)\ (D*XCgp_i) ;



clear L2 jk0V_i XCgp_i temp;