function CGH_pattern = hologram_encoding(complex_sum,encoding_type,scaling_factor, crop_on, crop_size, dc_on);
%% 2022/01/03 ��������: full complex�� �ѿ������� full_phase�� �����ϰ� ����
%% crop��ɰ� dc�߰� ����� ������ �и��Ͽ���
global Nx Ny

switch encoding_type
    case 'binary_encoding'
        CGH_pattern = single(real(complex_sum)>0);     
    case 'full_phase'
        CGH_pattern = complex_sum./(abs(complex_sum)+eps);
    case 'full_phase_threshold'
        CGH_pattern = complex_sum./(abs(complex_sum)+eps).*(abs(complex_sum) > 0.05*max(max(abs(complex_sum))));
    case 'full_complex'
        norm_factor = sum(sum(abs(complex_sum)));
        CGH_pattern = complex_sum./norm_factor*(Nx*Ny); %���⸦ �ٸ� ���� �ϰ��ǰ� ���߰��� ��
    case 'double_phase'
        phase1 = angle(complex_sum)+acos(abs(complex_sum)./max(max(abs(complex_sum))));
        phase2 = angle(complex_sum)-acos(abs(complex_sum)./max(max(abs(complex_sum))));
        M = (checkerboard(scaling_factor,Ny/(2*scaling_factor),Nx/(2*scaling_factor)) > 0.5);
        phase = phase1.*(~M)+phase2.*M;
        CGH_pattern = exp(+1j*phase);
end

if dc_on
CGH_pattern = CGH_pattern + 1 ;
end

if crop_on
y_range = (size(complex_sum,1)-crop_size(1))/2 + [1:crop_size(1)];   
x_range = (size(complex_sum,2)-crop_size(2))/2 + [1:crop_size(2)]; 
temp = zeros(size(complex_sum));    
temp(y_range,x_range,:) = CGH_pattern(y_range,x_range,:);
CGH_pattern = temp;
end

end