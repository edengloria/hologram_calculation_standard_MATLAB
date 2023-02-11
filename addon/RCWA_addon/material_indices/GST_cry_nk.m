%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=GST_cry_nk(lambda);

lambda=lambda*10^9;

Au_data=[276.1	0.765	2.05;
284	0.785	2.135;
292.3	0.8	2.25;
301.2	0.875	2.32;
310.6	0.88	2.435;
320.6	0.9	2.55;
331.3	0.98	2.63;
342.7	1.07	2.75;
355	1.125	2.85;
368.1	1.22	2.96;
382.3	1.3	3.1;
397.6	1.4	3.22;
414.1	1.6	3.3;
432.1	1.7	3.45;
451.8	1.875	3.62;
473.3	2.05	3.745;
497	2.25	3.87;
523.1	2.5	3.97;
552.2	2.75	4.124;
584.6	3.03	4.2;
621.2	3.3	4.25;
662.6	3.65	4.28;
709.9	4.025	4.3;
764.5	4.3	4.315;
828.3	4.8	4.305;
903.5	5.26	4.31;
993.9	5.83	4.15;
1104.3	6.5	3.75;
1242.4	6.9	3.06;
1419.9	7.125	2.375;
1656.5	6.24	2.06;

];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;