xx = single(linspace(-px*Nx/2,+px*Nx/2,Nx)); % ���� ������ ���� ����
yy = single(linspace(-py*Ny/2,+py*Ny/2,Ny)); % -py*Ny/2,+py*Ny/2 ���̿� Ny����ŭ ����
dfx = 1/px/Nx; dfy = 1/py/Ny;        % ���ļ� ������ ���� ����
uu = single(dfx*[-Nx/2+1:Nx/2]); % sin_thx= 2*pi*uu/k0; 
vv = single(dfy*[-Ny/2+1:Ny/2]);

% sin_thx= 2*pi*uu/k0; 
% sin_thy= 2*pi*vv/k0; 