%% 재생파가 참조파와 동일한 경우 
if strcmp(recon_cond,'same as reference')
    theta_recon = theta_ref;    phi_recon = phi_ref; point_recon = point_ref;
end
%% 재생파가 점광원인 경우
if strcmp(recon_cond,'point') || (strcmp(recon_cond,'same as reference') && strcmp(ref_cond,'point'))
    theta_recon = 0;    phi_recon = 0;
    for lm_cnt = 1:1:length(lambda_)
        lambda = lambda_(lm_cnt); prepare_lambda_k0_xx_yy_dfx_uu_vv; %k0,limit angle 정의, xx,yy,uu,vv,dfx 설정
        phase_ref = k0*sqrt((repmat(xx,size(yy.'))-point_recon(1)).^2 + (repmat(yy.',size(xx))-point_recon(2)).^2 + point_recon(3).^2);
        CGH_pattern(:,:,lm_cnt) = CGH_pattern(:,:,lm_cnt).*exp(-j*phase_ref);
        clear phase_ref;
    end
end