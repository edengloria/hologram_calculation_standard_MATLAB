function Epsr_pml=build_PML_lalanne_test(pml_width, pml_N, gambda, M, n_surr, Epsr_ori, e_or_a);

% USAGE
% pml_width=1/5*gambda_x;   % 한쪽 방향의 PML 두께
% pml_N=30;   % 한쪽 방향으로 staircase 개수
% 
% Epg=build_PML(pml_width, pml_N, gambda_x, Mx, n0, Epg, 0);
% Apg=build_PML(pml_width, pml_N, gambda_x, Mx, n0, Apg, 1);

% PML 기본 변수 설정
pml_num=[1:pml_N];
p_factor=[0.947 1.043 4.552 7.343];

%%% Model 2
pml_index=n_surr+(p_factor(1)*(pml_num/pml_N)).^p_factor(3)...
    +j*(p_factor(2)*(pml_num/pml_N)).^p_factor(4);

%%% Model 1
% pml_index=n_surr+j*(pml_num/pml_N);

if e_or_a==1   % apsr
    pml_index=1./pml_index;
    n_surr=1/n_surr;
elseif e_or_a~=0
    error(' Epsr = 0 / Apsr = 1');
end

pml_epsr=pml_index.^2;
pml_fill_factor=(gambda-2*pml_width*fliplr(pml_num)/pml_N)/gambda;
Epsr_pml=Epsr_ori;



% 첫번째 PML build
f_pml=pml_fill_factor(1);
ng_gr1=sqrt(pml_epsr(1));
ng_gr2=n_surr;

Epsr_pml_t1=rect_epsr_1D(n_surr,ng_gr1,gambda,M,f_pml,0);
Epsr_pml_t2=rect_epsr_1D(n_surr,ng_gr2,gambda,M,f_pml,0);
Epsr_pml=Epsr_pml+Epsr_pml_t1-Epsr_pml_t2;



% 두번째 이후 PML build
for cnt=2:pml_N
    f_pml=pml_fill_factor(cnt);
    ng_gr1=sqrt(pml_epsr(cnt));
    ng_gr2=sqrt(pml_epsr(cnt-1));
    Epsr_pml_t1=rect_epsr_1D(n_surr,ng_gr1,gambda,M,f_pml,0);
    Epsr_pml_t2=rect_epsr_1D(n_surr,ng_gr2,gambda,M,f_pml,0);
    Epsr_pml=Epsr_pml+Epsr_pml_t1-Epsr_pml_t2;
end

    
    
    
    