function [Epsr_PML Apsr_PML p_factor] = PRCWA_Gen_PML2D(pml_width,pml_N,n_surr,Nx,Ny,gambda_x,gambda_y)
% pml_width   = 1.5*um;   % 한쪽 방향의 PML 두께
% pml_N       = 30;   % 한쪽 방향으로 staircase 개수



% Set PML variables
NBx         = (Nx+1)/2;
NBy         = (Ny+1)/2;
epra        = n_surr ^ 2;
pml_num     = [1 : pml_N];
% p_factor    = [0.347 1.443 0.252 0.143]; % Tx=14um Mx=My=29
p_factor    = [0.947 1.043 1.052 1.343];% 1*um 
% p_factor    = [0.347 .343 .552 .543];
pml_index   = n_surr ...
                  +     (p_factor(1)*(pml_num/pml_N)).^p_factor(3) ...
                  + j * (p_factor(2)*(pml_num/pml_N)).^p_factor(4);                     % clear p_factor
% pml_index   = n_surr ...
%                   + j * (p_factor(2)*(pml_num/pml_N)).^p_factor(4);                     % clear p_factor
% pml_index   = n_surr *ones(size(pml_num));                     % clear p_factor

              
              
pml_epsr    = pml_index.^2;                                                             % clear pml_index

pml_fill_factor             = (gambda_x-2*pml_width*fliplr(pml_num)/pml_N)/gambda_x;    % clear pml_num
pml_fill_factor(pml_N+1)    = 1;

Epsr_PML    = zeros(Nx,Ny);
Apsr_PML    = zeros(Nx,Ny);

%% non-PML area 
pml_wx       = pml_fill_factor(1) * gambda_x/2;
pml_wy       = pml_fill_factor(1) * gambda_y/2;
for mm=1:Nx
    for nn=1:Ny
        
            m=mm-NBx;
            n=nn-NBy;
            
            Epsr_PML(mm,nn) =   epra*rect_2D(m,n,1,gambda_x,gambda_y,-pml_wx,+pml_wx,-pml_wy,+pml_wy);
            Apsr_PML(mm,nn) = 1/epra*rect_2D(m,n,1,gambda_x,gambda_y,-pml_wx,+pml_wx,-pml_wy,+pml_wy);
            
    end % for nn
end % for mm

%% Gen PML
for k = 1:pml_N
    f_pml1  = pml_fill_factor(k);
    f_pml2  = pml_fill_factor(k+1);

    pml1_wx       = f_pml1 * gambda_x/2;
    pml1_wy       = f_pml1 * gambda_y/2;
    pml2_wx       = f_pml2 * gambda_x/2;
    pml2_wy       = f_pml2 * gambda_y/2;

    for mm = 1:Nx
        for nn = 1:Ny
            m = mm-NBx;
            n = nn-NBy;
            t =  rect_2D(m,n,1,gambda_x,gambda_y,-pml2_wx,+pml2_wx,-pml2_wy,+pml2_wy) ...
                -rect_2D(m,n,1,gambda_x,gambda_y,-pml1_wx,+pml1_wx,-pml1_wy,+pml1_wy);
            Epsr_PML(mm,nn) = Epsr_PML(mm,nn) +   pml_epsr(k) * t;
            Apsr_PML(mm,nn) = Apsr_PML(mm,nn) + 1/pml_epsr(k) * t;
        end
    end
    Fourier_coeff_2D_show(Apsr_PML,11,Nx,Ny,gambda_x,gambda_y);
%     k
%     pause(0.2);
end

return