f_pml       =   1/(1+1*i);
gamma_pml   = .0*i;
f_n       = zeros(1,Nx);
q         = 2*pml_width;
M_        = linspace(-2*Mx,2*Mx,Nx);
f_n       = -q/(2*gambda_x)*(-1).^M_.* ...
                    ((1+gamma_pml/4).*sinc(M_*q/gambda_x)+0.5*sinc(M_*q/gambda_x-1)+0.5*sinc(M_*q/gambda_x+1) ...
                     +(gamma_pml/8)*sinc(M_*q/gambda_x-2)+(gamma_pml/8)*sinc(M_*q/gambda_x+2)) ;   
f_n(2*Mx+1) = f_n(2*Mx+1)+1 ;

Fourier_coeff_1D_show(f_n(:,:) ,70+4,Nx,Tx);

Fn_toep_layer(:,:)        = folded_toeplitz_1D(f_n(:,:));