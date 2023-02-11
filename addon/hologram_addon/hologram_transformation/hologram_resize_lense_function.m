function CGH_pattern_out =  hologram_resize_lense_function(CGH_pattern,magnification_factor,image_center);
%% 실패.. 파장 변환시 응용 가능할듯? %%
%%

global Nx Ny px py lambda;

xx = single(linspace(-px*Nx/2,+px*Nx/2,Nx)); % 선형 간격의 벡터 생성
yy = single(linspace(-py*Ny/2,+py*Ny/2,Ny)); % -py*Ny/2,+py*Ny/2 사이에 Ny개만큼 생성
[x y] = meshgrid(xx,yy);

dfx = 1/px/Nx; dfy = 1/py/Ny;        % 주파수 도메인 벡터 생성
uu = single(dfx*[-Nx/2+1:Nx/2]);
vv = single(dfy*[-Ny/2+1:Ny/2]);
[u, v] = meshgrid(uu,vv);


if magnification_factor == 1
     CGH_pattern_out =  CGH_pattern; % do nothing
else 

f_lense = magnification_factor*image_center/(magnification_factor-1);
CGH_pattern = CGH_pattern.*exp(-j*pi*(x.^2 + y.^2)/lambda/f_lense);

shift_xyz = [0 0 -(magnification_factor-1)*image_center];
CGH_pattern_out = hologram_shift_spatial_domain(CGH_pattern,shift_xyz,u,v);


end

end