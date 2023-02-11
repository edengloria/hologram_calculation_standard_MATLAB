colormap hot;
cmap=colormap;

%% green laser
% temp=linspace(1,-1.8,64);
% temp2=linspace(3,-1,64);
% cmap(:,2)=1./(1+exp(temp/0.35));
% cmap(:,1)=1./(1+exp(temp2/0.5));
% cmap(:,3)=1./(1+exp(temp2/0.5));
% cmap(1,:)= 0;
% xx=linspace(0,1,64);
% 
% 
% figure(1)
% imagesc(xx);colormap(cmap);

%% red laser
temp=linspace(1,-1.8,64);
temp2=linspace(3,-1.2,64);
temp3=linspace(3,-1.2,64);
cmap(:,1)=1./(1+exp(temp/0.35));
cmap(:,2)=1./(1+exp(temp2/0.4));
cmap(:,3)=1./(1+exp(temp3/0.4));
cmap(1,:)= 0;
xx=linspace(0,1,64);


figure(1)
imagesc(xx);colormap(cmap);

%% blue laser
temp=linspace(1,-1.8,64);
temp2=linspace(3,-1.1,64);
temp3=linspace(3,-1.3,64);
cmap(:,3)=1./(1+exp(temp/0.35));
cmap(:,1)=.85./(1+exp(temp2/0.5));
cmap(:,2)=1./(1+exp(temp3/0.5));
cmap(1,:)= 0;
xx=linspace(0,1,64);


figure(1)
imagesc(xx);colormap(cmap);

%% new rdb
%  temp=linspace(0,1,64);
% cmap(:,2)=0;
% cmap(:,1)=2./(1+exp(abs(temp-0.25)/0.03));
% cmap(:,3)=2./(1+exp(abs(temp-0.75)/0.03));
% xx=linspace(0,1,64);
% 
% 
% figure(1)
% imagesc(xx);colormap(cmap);