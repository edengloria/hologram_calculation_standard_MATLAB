xx = single(linspace(-px*Nx/2,+px*Nx/2,Nx)); % 선형 간격의 벡터 생성
yy = single(linspace(-py*Ny/2,+py*Ny/2,Ny)); % -py*Ny/2,+py*Ny/2 사이에 Ny개만큼 생성
dfx = 1/px/Nx; dfy = 1/py/Ny;        % 주파수 도메인 벡터 생성
uu = single(dfx*[-Nx/2+1:Nx/2]); % sin_thx= 2*pi*uu/k0; 
vv = single(dfy*[-Ny/2+1:Ny/2]);

% sin_thx= 2*pi*uu/k0; 
% sin_thy= 2*pi*vv/k0; 