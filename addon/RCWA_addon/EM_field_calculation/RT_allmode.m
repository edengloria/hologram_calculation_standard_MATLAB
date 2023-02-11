function [R, T] = RT_allmode(Wtemp1, Vtemp1, Wtemp2, Vtemp2, Cgp, Cgn)
global TETM L;

if strcmp(TETM, 'TM') || strcmp(TETM, 'TE')
 Si  = Wtemp1*Cgp(:,:,1);           
 Ui  = conj(Vtemp1*Cgp(:,:,1));
 Pi  = real((-j)*sum(Si.*Ui));

 Sr  = Wtemp1*Cgn(:,:,1);           
 Ur  = conj(Vtemp1*Cgn(:,:,1));
 Pr  = real((-j)*sum(Sr.*Ur));

 St  = Wtemp2*Cgp(:,:,end);           
 Ut  = conj(Vtemp2*Cgp(:,:,end));
 Pt  = real((-j)*sum(St.*Ut)); 
elseif strcmp(TETM, 'both')
 Si  = Wtemp1*Cgp(:,:,1);           
 Ui  = conj(Vtemp1*Cgp(:,:,1));
 Pi  = real((-j)*sum(Si(1:L).*Ui(L+1:2*L))  -  (-j)*sum(Si(L+1:2*L).*Ui(1:L)) );

 Sr  = Wtemp1*Cgn(:,:,1);           
 Ur  = conj(Vtemp1*Cgn(:,:,1));
 Pr  = real((-j)*sum(Sr(1:L).*Ur(L+1:2*L))  -  (-j)*sum(Sr(L+1:2*L).*Ur(1:L)) );

 St  = Wtemp2*Cgp(:,:,end);           
 Ut  = conj(Vtemp2*Cgp(:,:,end));
 Pt  = real((-j)*sum(St(1:L).*Ut(L+1:2*L))  -  (-j)*sum(St(L+1:2*L).*Ut(1:L)) ); 
    
end
 R = Pr/Pi;   T = Pt/Pi;
 
 
 disp(['Reflected   power: ' num2str(R*100) '%' ]);
 disp(['Transmitted power: ' num2str(T*100) '%' ]);
 disp(['Absorbed    power: ' num2str((1-T-R)*100) '%' ]);
 if (R+T) > 1.001
 warning(['R+T 값이 1을 초과합니다!! Gain물질이 없는 경우 시뮬레이션이 잘못되었을 가능성이 큽니다 '])
 end
end