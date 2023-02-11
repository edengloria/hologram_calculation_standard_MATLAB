clear all
close all
clc

%%
ll=linspace(200,1000,501);len_ll=length(ll);

ag=zeros(1,len_ll);
au=zeros(1,len_ll);
si=zeros(1,len_ll);

for q=1:len_ll
    l=ll(q)*1e-9;
    ag(q)=Ag_nk(l);
    au(q)=Au_nk(l);
    si(q)=Si_nk(l);
end

%%
figure(1);
subplot(3,2,1);
plot(ll,real(ag),'r');hold on;box on;grid on;
plot(ll,imag(ag),'b');
xlabel('Wavelength (nm)');
title('Ag (n+ik)');
subplot(3,2,2);
plot(ll,real(ag.^2),'r');hold on;box on;grid on;
plot(ll,imag(ag.^2),'b');
xlabel('Wavelength (nm)');
title('Ag (\epsilon)');
subplot(3,2,3);
plot(ll,real(au),'r');hold on;box on;grid on;
plot(ll,imag(au),'b');
xlabel('Wavelength (nm)');
title('Au (n+ik)');
subplot(3,2,4);
plot(ll,real(au.^2),'r');hold on;box on;grid on;
plot(ll,imag(au.^2),'b');
xlabel('Wavelength (nm)');
title('Au (\epsilon)');
subplot(3,2,5);
plot(ll,real(si),'r');hold on;box on;grid on;
plot(ll,imag(si),'b');
xlabel('Wavelength (nm)');
title('Si (n+ik)');
subplot(3,2,6);
plot(ll,real(si.^2),'r');hold on;box on;grid on;
plot(ll,imag(si.^2),'b');
xlabel('Wavelength (nm)');
title('Si (\epsilon)');
