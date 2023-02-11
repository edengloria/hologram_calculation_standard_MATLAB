%         disp('Calculating WQXV..');
        t1=clock;

switch Dimension
%% 2D RCWA
    case '2D'
[Kx]                   = get_Kx_col(NBx,Tx,kx);
if strcmp(TETM,'TM') | strcmp(TETM,'TE')
        W__ = zeros(L,L,layer_type_num); V__ = zeros(L,L,layer_type_num);  
        Q__ = zeros(L,1,layer_type_num);  X__ = zeros(L,1,layer_type_num);  
        iE__= zeros(L,L,layer_type_num);
        
if strcmp(TETM,'TM')
        for cnt=1:layer_type_num
%         t2=clock;
%         disp(['Calculating layer ' num2str(cnt)]); 
            if pml_(cnt)==3 % CPML
       [W__(:,:,cnt) Q__(:,:,cnt) X__(:,:,cnt) V__(:,:,cnt) iE__(:,:,cnt)]    = eigen_solve_1D_RCWA_TM_lalanne(Ep_toep_layer(:,:,cnt) ,Ap_toep_layer(:,:,cnt),Bp_toep_layer(:,:,cnt) ,Fn_toep_layer,f_pml,0,diag(Kx/k0),k0,0);
           else
       [W__(:,:,cnt) Q__(:,:,cnt) X__(:,:,cnt) V__(:,:,cnt) iE__(:,:,cnt)]    = eigen_solve_1D_RCWA_TM(Ep_toep_layer(:,:,cnt) ,Ap_toep_layer(:,:,cnt) ,0,diag(Kx/k0),k0,0);
            end
 %         disp(['       done.  elapsed time : ' num2str(etime(clock,t2))]);   
           
        end
elseif strcmp(TETM,'TE')
        for cnt=1:layer_type_num
%         t2=clock;
%         disp(['Calculating layer ' num2str(cnt)]);            
            if pml_(cnt)==3 % CPML TE not yet!!
%         [W__(:,:,cnt) Q__(:,:,cnt) X__(:,:,cnt) V__(:,:,cnt) iE__(:,:,cnt)]    = eigen_solve_for_1D_RCWA_col_invE_lalanne(Ep_toep_layer(:,:,cnt) ,Ap_toep_layer(:,:,cnt),Bp_toep_layer(:,:,cnt) ,Fn_toep_layer,f_pml,0,diag(Kx/k0),k0,0);
            else
        [W__(:,:,cnt) Q__(:,:,cnt) X__(:,:,cnt) V__(:,:,cnt) iE__(:,:,cnt)]    = eigen_solve_1D_RCWA_TE(Ep_toep_layer(:,:,cnt) ,Ap_toep_layer(:,:,cnt) ,0,diag(Kx/k0),k0,0);  
            end
 %         disp(['       done.  elapsed time : ' num2str(etime(clock,t2))]);            
        end
else
end


    elseif strcmp(TETM,'both')
        Ky = repmat(ky,[length(Kx) 1]);
        W__ = zeros(2*L,2*L,layer_type_num);    V__ = zeros(2*L,2*L,layer_type_num);
        Q__ = zeros(2*L,1,layer_type_num);       X__ = zeros(2*L,1,layer_type_num);
        iE__= zeros(L,L,layer_type_num);
        
        for cnt=1:layer_type_num
%         t2=clock;
%         disp(['Calculating layer ' num2str(cnt)]); 
        if strcmp(Mu_active,'on')
        [W__(:,:,cnt) Q__(:,:,cnt) X__(:,:,cnt) V__(:,:,cnt) iE__(:,:,cnt)]    = eigen_solve_1D_RCWA_both_mu(Ep_toep_layer(:,:,cnt) ,Ap_toep_layer(:,:,cnt) ,Mp_toep_layer(:,:,cnt),Bp_toep_layer(:,:,cnt),0,diag(Kx/k0),ky/k0,k0,0);    
        else
        [W__(:,:,cnt) Q__(:,:,cnt) X__(:,:,cnt) V__(:,:,cnt) iE__(:,:,cnt)]    =eigen_solve_1D_RCWA_both(Ep_toep_layer(:,:,cnt) ,Ap_toep_layer(:,:,cnt) ,0,diag(Kx/k0),ky/k0,k0,0);
%         disp(['       done.  elapsed time : ' num2str(etime(clock,t2))]);   
        end
        end
    else
end

    

%% 3D RCWA 
    case '3D'
[Kx  Ky]                   = get_Kx_Ky_col(NBx,NBy,Tx,Ty,kx,ky);
        t1=clock;
        W__ = zeros(2*L,2*L,layer_type_num);        V__ = zeros(2*L,2*L,layer_type_num);
        Q__ = zeros(2*L,1,layer_type_num);           X__ = zeros(2*L,1,layer_type_num);
        iE__= zeros(L,L,layer_type_num);
        
        for cnt=1:layer_type_num
        t2=clock;
%         disp(['Calculating layer ' num2str(cnt)]); 
        [W__(:,:,cnt) Q__(:,1,cnt) X__(:,1,cnt) V__(:,:,cnt) iE__(:,:,cnt)]    =eigen_solve_2D_RCWA(Ep_toep_layer(:,:,cnt) ,Ap_toep_layer(:,:,cnt) ,0,diag(Kx/k0),diag(Ky/k0),k0,0);
%         disp(['       done.  elapsed time : ' num2str(etime(clock,t2))]);   
        end
 
end

% disp(['       done.  total WQXV elapsed time : ' num2str(etime(clock,t1))]);
clear Epg_toep_layer Apg_toep_layer X__