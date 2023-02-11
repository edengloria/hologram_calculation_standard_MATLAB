k0 = 2*pi/lambda;          % 파장 정의, 공간주파수 정의
Ideal_angle_limit = asind(lambda/px/2)- 0.0001; % limit angle 정의

xx = (linspace(-px*Nx/2+px/2,+px*Nx/2-px/2,Nx)); % 선형 간격의 벡터 생성
yy = (linspace(-py*Ny/2+py/2,+py*Ny/2-py/2,Ny)); % -py*Ny/2,+py*Ny/2 사이에 Ny개만큼 생성
dfx = 1/px/Nx; dfy = 1/py/Ny;        % 주파수 도메인 벡터 생성
uu = (dfx*[-Nx/2+1/2:Nx/2-1/2]); % sin_thx= 2*pi*uu/k0; 
vv = (dfy*[-Ny/2+1/2:Ny/2-1/2]);

% sin_thx= 2*pi*uu/k0; 
% sin_thy= 2*pi*vv/k0; 