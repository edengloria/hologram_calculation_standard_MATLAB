function [R_diff, T_diff] = RT_eachmode(Wtemp1, Vtemp1, Wtemp2, Vtemp2, Cgp, Cgn)
global TETM L Dimension;

R_diff = zeros(size(Cgp,1),1);
T_diff = zeros(size(Cgp,1),1);

if strcmp(TETM, 'TM') || strcmp(TETM, 'TE')
    
 Si  = Wtemp1*Cgp(:,:,1);           
 Ui  = conj(Vtemp1*Cgp(:,:,1));
 Pi  = real((-j)*sum(Si.*Ui));

 tCgn_r = diag(Cgn(:,:,1));  
 tCgp_t = diag(Cgp(:,:,end));

 Sr  = Wtemp1*tCgn_r;           
 Ur  = conj(Vtemp1*tCgn_r);
 Pr  = real((-j)*sum(Sr.*Ur,1));

 St  = Wtemp2*tCgp_t;           
 Ut  = conj(Vtemp2*tCgp_t);
 Pt  = real((-j)*sum(St.*Ut,1)); 

 R_diff = Pr/Pi;   T_diff = Pt/Pi;  

elseif strcmp(TETM, 'both')
  Si  = Wtemp1*Cgp(:,:,1);           
  Ui  = conj(Vtemp1*Cgp(:,:,1));
  Pi  = real((-j)*sum(Si(1:L).*Ui(L+1:2*L))  -  (-j)*sum(Si(L+1:2*L).*Ui(1:L)) );
   
tCgn_r = diag(Cgn(:,:,1));  
tCgp_t = diag(Cgp(:,:,end));

 Sr  = Wtemp1*tCgn_r;           
 Ur  = conj(Vtemp1*tCgn_r);
 Pr  = real((-j)*sum(Sr(1:L,:).*Ur(L+1:2*L,:))  -  (-j)*sum(Sr(L+1:2*L,:).*Ur(1:L,:)) );

 St  = Wtemp2*tCgp_t;           
 Ut  = conj(Vtemp2*tCgp_t);
 Pt  = real((-j)*sum(St(1:L,:).*Ut(L+1:2*L,:))  -  (-j)*sum(St(L+1:2*L,:).*Ut(1:L,:)) ); 
 
 R_diff = Pr/Pi;   T_diff = Pt/Pi;  


%% both 인 경우 TE, TM 성분을 분리하고, 3D의 경우 x,y로도 분리한다
    if strcmp(Dimension, '2D') 
    R_diff = reshape(R_diff,[length(Cgp)/2,2]);
    T_diff = reshape(T_diff,[length(Cgp)/2,2]);
    elseif strcmp(Dimension, '3D') 
    R_diff = reshape(R_diff,[sqrt(length(Cgp)/2),sqrt(length(Cgp)/2),2]);
    T_diff = reshape(T_diff,[sqrt(length(Cgp)/2),sqrt(length(Cgp)/2),2]);
    end

end




end


