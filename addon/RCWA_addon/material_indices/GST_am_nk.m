%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=GST_am_nk(lambda);

lambda=lambda*10^9;

Au_data=[276.1	1.51	2.22;
284	1.58	2.25;
292.3	1.65	2.27;
301.2	1.73	2.32;
310.6	1.79	2.375;
320.6	1.875	2.4;
331.3	2	2.49;
342.7	2.1	2.52;
355	2.2	2.54;
368.1	2.3	2.57;
382.3	2.48	2.6;
397.6	2.65	2.615;
414.1	2.75	2.62;
432.1	2.875	2.615;
451.8	3.05	2.6;
473.3	3.2	2.58;
497	3.3	2.54;
523.1	3.5	2.45;
552.2	3.7	2.39;
584.6	3.8	2.3;
621.2	4	2.18;
662.6	4.13	2.05;
709.9	4.28	1.9;
764.5	4.49	1.745;
828.3	4.6	1.51;
903.5	4.67	1.25;
993.9	4.7	0.9;
1104.3	4.74	0.625;
1242.4	4.7	0.43;
1419.9	4.65	0.26;
1656.5	4.48	0.128;

];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;