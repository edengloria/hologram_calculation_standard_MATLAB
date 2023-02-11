function v = null_jh(A)

A_1         = -A(:,1);
A_2_end     = A(:,2:end);

v_1         = 1;
v_2_end     = pinv(A_2_end)*A_1;

v           = vertcat(v_1,v_2_end);
% v           = v/norm(v);

return
