function [F,G,Wtemp,Vtemp,B,invA_X] = RCWA2D_ETMM_general_first_TMandTE(W__, Q__, V__,depth,width_type,Total_layer_num,L,k0,Kx,ky,dc_profile,NBx);  

layer_num   = Total_layer_num-2;
layer_input = 1;
layer_first = 2;
layer_last  = Total_layer_num-1;
layer_ouput = Total_layer_num;

Ky = repmat(ky,[length(Kx) 1]);
% Cgp                             = zeros( 2*L,1  ,Total_layer_num);
% Cgn                             = zeros( 2*L,1  ,Total_layer_num);
% Cgp(:,:,layer_input)       = Cgpin;   % for plane wave normalization, use cosd(theta0)    

%%
if width_type(end) == 0 && dc_profile(end) ~=0

[Wtemp, Vtemp, Kz] =get_WV_for_dc_layer_Kx_Ky(Kx,Ky,sqrt(dc_profile(end)),k0);
    
%     Wtemp = eye(size(W__(:,:,1)));
% 
%     [KI Kz] = get_KI_from_Kx_Ky_n0(Kx,Ky,real(sqrt(dc_profile(end))),k0,L);
%     Vtemp = KI/k0/j;
else
    Wtemp = W__(:,:,width_type(end));
    Vtemp = V__(:,:,width_type(end));
end

if layer_num == 0
    [F G]                                       = enhanced_T_at_last_boundary_col(Wtemp,Vtemp,k0);
else
    [Fprev Gprev]                               = enhanced_T_at_last_boundary_col(Wtemp,Vtemp,k0);
end

invA_X = zeros(2*L,2*L,layer_ouput);
B      = zeros(2*L,2*L,layer_ouput);

if layer_num ~= 0
for cnt=Total_layer_num-1:-1:2 
    if width_type(cnt) == 0 && dc_profile(cnt) ~=0
[Wtemp, Vtemp, Kz] =get_WV_for_dc_layer_Kx_Ky(Kx,Ky,sqrt(dc_profile(cnt)),k0);        
%     Wtemp = eye(size(W__(:,:,1)));
%     Ky = repmat(ky,[length(Kx) 1]);
%     [KI Kz] = get_KI_from_Kx_Ky_n0(Kx,Ky,real(sqrt(dc_profile(cnt))),k0,L);
%     Vtemp = KI/k0/j;
    Qtemp   = j*[Kz; Kz];
    Xtemp = exp(Qtemp*depth(cnt));
    else
    Wtemp = W__(:,:,width_type(cnt));
    Vtemp = V__(:,:,width_type(cnt));
    Xtemp = exp(Q__(:,1,width_type(cnt))*depth(cnt));
    end
    
%     disp([' ETMM calculation layer  ' num2str(cnt-1) '/' num2str(layer_last-1)]);
    [invA_X(:,:,cnt) B(:,:,cnt) F G]                = enhanced_T_from_last_to_first_col_new(Wtemp,Xtemp,Vtemp,Fprev,Gprev,k0);

    Fprev = F;
    Gprev = G;
    
end
end

if width_type(1) == 0 && dc_profile(1) ~=0
[Wtemp, Vtemp, Kz]=get_WV_for_dc_layer_Kx_Ky(Kx,Ky,sqrt(dc_profile(1)),k0);       
%     Wtemp = eye(size(W__(:,:,1)));
%     Ky = repmat(ky,[length(Kx) 1]);
%     [KI Kz] = get_KI_from_Kx_Ky_n0(Kx,Ky,real(sqrt(dc_profile(1))),k0,L);
%     Vtemp = KI/k0/j;
else
    Wtemp = W__(:,:,width_type(1));
    Vtemp = V__(:,:,width_type(1));
end


end

