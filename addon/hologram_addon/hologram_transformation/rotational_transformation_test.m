function CGH_pattern = rotational_transformation_test(CGH_pattern,theta_x,theta_y,theta_z,x,y)

global lambda px py Nx Ny;

dfx = 1/px/Nx; dfy = 1/py/Ny;        % 주파수 도메인 벡터 생성
uu = single(dfx*[-Nx/2+1:Nx/2]);
vv = single(dfy*[-Ny/2+1:Ny/2]);
[u, v] = meshgrid(uu,vv);
w = sqrt(1/lambda^2-(u).^2 - (v).^2);

ra_x = deg2rad(theta_x); Rx = [1 0 0; 0 cos(ra_x) sin(ra_x); 0 -sin(ra_x) cos(ra_x)];
ra_y = deg2rad(theta_y); Ry = [cos(ra_y) 0 -sin(ra_y); 0 1 0; sin(ra_y) 0 cos(ra_y)];
ra_z = deg2rad(theta_z); Rz = [cos(ra_z) sin(ra_z) 0; -sin(ra_z) cos(ra_z) 0; 0 0 1];

a = Rx*Ry*Rz;

% hu = a(1)*u + a(4)*v + a(7)*w; hx = a(1)*x + a(4)*y;  
% hv = a(2)*u + a(5)*v + a(8)*w; hy = a(2)*x + a(5)*y;  
% hw = sqrt(1/lambda^2-(hu).^2 - (hv).^2);

u0 = a(3)./lambda; 
v0 = a(6)./lambda; 

%%
h_u = u; h_v = v; h_w = w;
alpha = (a(1).*h_u)+(a(2).*h_v)+(a(3).*h_w);
beta = (a(4).*h_u)+(a(5).*h_v)+(a(6).*h_w);
%%

jacobian = (((a(2)*a(6)-a(3)*a(5)).*h_u)./h_w)...
          +(((a(3)*a(4)-a(1)*a(6)).*h_v)./h_w)...
            +(a(1)*a(5)-a(2)*a(4));

%  jacobian = (a(1)*a(5)-a(2)*a(4));

CGH_pattern = ifftshift(fft2(fftshift(CGH_pattern))); % F(u,v)

CGH_pattern_h = zeros(size(CGH_pattern));

alpha_map = round((alpha-u0)/dfx)+Nx/2; % 가까운값 -> interpol 값으로..
beta_map = round((beta-v0)/dfx)+Nx/2;

 for hu_cnt = 1:size(h_u,2)
     for hv_cnt = 1:size(h_u,1)
         
         v_num = beta_map(hv_cnt,hu_cnt);
         u_num = alpha_map(hv_cnt,hu_cnt);
         
         if (v_num>=1)&(v_num<=Ny)&(u_num>=1)&(u_num<=Nx)
             CGH_pattern_h(hv_cnt,hu_cnt) = CGH_pattern(v_num,u_num);
         end
     end
 end

CGH_pattern = CGH_pattern_h.*abs(jacobian);

CGH_pattern = fftshift(ifft2(ifftshift(CGH_pattern))).*exp(j*2*pi*(u0*x+v0*y));

end
