%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=GST_am200_nk(lambda);

lambda=lambda*10^9;

Au_data=[275	1.52754	2.03433;
283	1.58672	2.08674;
291	1.64852	2.13561;
300	1.72032	2.18623;
310	1.80218	2.23718;
319	1.87811	2.27889;
330	1.9716	2.32375;
342	2.07496	2.36588;
354	2.17858	2.40097;
367	2.29064	2.43147;
381	2.41081	2.4561;
396	2.537	2.4734;
413	2.67652	2.48267;
431	2.81913	2.48169;
450	2.96308	2.47004;
472	3.1209	2.44479;
496	3.28204	2.40515;
522	3.44178	2.3513;
551	3.60261	2.28129;
583	3.76123	2.19508;
619	3.9185	2.09036;
661	4.07473	1.96368;
708	4.2215	1.81848;
763	4.36097	1.64741;
826	4.48368	1.45269;
901	4.58452	1.22189;
991	4.64112	0.95334;


];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;