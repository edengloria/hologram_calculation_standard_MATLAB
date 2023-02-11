function [out_r,out_i] = dl_STFT_complex_1D(in_r, in_i)

%% 실수허수 사이즈가 다르면 에러
if length(in_r) == length(in_i)
    array_size = length(in_r);
else
    error(['Real and Imag array length is not same!']);
end

%% column vector 입력시 row vector로 바꾼다
if size(in_r,1) ~= 1;  in_r = in_r' ;  end
if size(in_i,1) ~= 1;  in_i = in_i' ;  end

%% 메인 계산
[dlstft_rr, dlstft_ri] = dlstft(in_r, 'Window',hann(array_size,'periodic'),'OverlapLength',0,'FFTLength',array_size,'DataFormat','CTB');
[dlstft_ir, dlstft_ii] = dlstft(in_i, 'Window',hann(array_size,'periodic'),'OverlapLength',0,'FFTLength',array_size,'DataFormat','CTB');

result_re_right = dlstft_rr-dlstft_ii; %최종 실수부 오른쪽
result_im_right = dlstft_ri+dlstft_ir; %최종 허수부 오른쪽
result_re_left = dlstft_rr+dlstft_ii; %최종 실수부 왼쪽
result_im_left = -dlstft_ri+dlstft_ir; %최종 허수부 왼쪽

out_r = [flip(result_re_left(1:end-1)) ;result_re_right(2:end)];
out_i = [flip(result_im_left(1:end-1)) ;result_im_right(2:end)];

%% 출력물은 column vector

end