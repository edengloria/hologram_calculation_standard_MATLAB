function [invA_X B F G] = enhanced_T_from_last_to_first_col_new(W,X,V,Fprev,Gprev,k0)

[L2 L2] = size(W);

jk0V = j*k0*V;

%% previous
% t11=clock;
% temp    = inv([W,W;jk0V,-jk0V]) * [Fprev;Gprev];
% disp(['       done.  elapsed time : ' num2str(etime(clock,t11))]);   

%% old
% t12=clock;
% temp    = [W,W;jk0V,-jk0V] \ [Fprev;Gprev];
% % disp(['       done.  elapsed time : ' num2str(etime(clock,t12))]);   
% A       = temp(   1:  L2,:);
% B       = temp(L2+1:2*L2,:);

%% new ¿ÃªÛ«‘
% t12=clock;
A = inv(W)/2*Fprev + inv(jk0V)/2*Gprev ;
B = inv(W)/2*Fprev - inv(jk0V)/2*Gprev ;

% disp(['       done.  elapsed time : ' num2str(etime(clock,t12))]);   
dX      = diag(X);

%% previous
% t21=clock;
% invA    = inv(A);
% invA_X  = invA * dX;
% disp(['       done.  elapsed time : ' num2str(etime(clock,t21))]);   

%% new
% t22=clock;
invA_X = A \ dX;
% disp(['       done.  elapsed time : ' num2str(etime(clock,t22))]); 

% sum(sum(invA_X))
% error2 = sum(sum(invA_X-invA_X2))
%%
XBiAX   = dX*B*invA_X;

% disp(['rcond(A) ' num2str(rcond(A)) '       rcond(X) ' num2str(rcond(X))]);
clear A;
Iden = eye(L2);

F           =    W * (Iden + XBiAX);
G           = jk0V * (Iden - XBiAX);
% G           = V * (Iden - XBiAX);

clear L2 jk0V temp XBiAX Iden;