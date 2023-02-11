%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=GST_am5_nk(lambda);

lambda=lambda*10^9;

Au_data=[275	1.31677	1.39537;
283	1.35511	1.43625;
291	1.39589	1.47487;
300	1.44403	1.51539;
310	1.49976	1.55671;
319	1.55211	1.59094;
330	1.61729	1.62826;
342	1.69009	1.66388;
354	1.76373	1.69415;
367	1.84396	1.72118;
381	1.93054	1.74397;
396	2.02196	1.76132;
413	2.12353	1.77293;
431	2.22777	1.77679;
450	2.33336	1.77253;
472	2.44945	1.75837;
496	2.5683	1.73342;
522	2.68636	1.69769;
551	2.80544	1.64986;
583	2.92307	1.58984;
619	3.03986	1.516;
661	3.15602	1.42582;
708	3.26528	1.32175;
763	3.36926	1.19847;
826	3.46091	1.05756;
901	3.53657	0.88996;
991	3.57977	0.69444;


];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;