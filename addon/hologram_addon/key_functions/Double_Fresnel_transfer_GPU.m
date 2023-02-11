function complex_sum = Double_Fresnel_transfer_GPU(input_data, xx, yy, virtual_propagation, z_propagation, DF_scale)
%% ARSS Fresnel Diffraction + Fresnel Diffraction
%% 참고논문 "Optics Express Vol. 25, No. 6, 2017"

global lambda lambda_ px py Nx Ny;

%% 1st step : Backward ARSS Fresnel Diffraction of d2
% xx, yy 는 SLM 기준 픽셀임

d1 = -virtual_propagation;  d2 = -(z_propagation-virtual_propagation);
dx = px*DF_scale;
dv = lambda*d1/Nx/px;
x_map = repmat(xx,size(yy.'));  y_map = repmat(yy.',size(xx));
ARSS_scale = dx/dv;

convergent_light = single(input_data).*exp(+1j*pi*((DF_scale*x_map).^2+(DF_scale*y_map).^2)/lambda/ (-d2));
step1_data = ARSS_transfer_GPU(convergent_light , dv*xx/px, dv*yy/py, -d2, ARSS_scale,0,0); 

% figure(20)
% imagesc(abs(step1_data));
%% 2nd step : Backward Fresnel Diffraction of d1
complex_sum = Fresnel_transfer_GPU(step1_data, xx, yy, 0, 0, -d1, 'after',1);

% figure(21)
% imagesc(abs(complex_sum));

end


