%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=GST_cry5_nk(lambda);

lambda=lambda*10^9;

Au_data=[275	0.80644	1.4631;
283	0.843	1.53722;
291	0.88239	1.60811;
300	0.92995	1.68428;
310	0.98655	1.76446;
319	1.04061	1.83259;
330	1.11056	1.91081;
342	1.19144	1.98974;
354	1.27671	2.06188;
367	1.37351	2.13215;
381	1.48243	2.19855;
396	1.60352	2.25871;
413	1.7451	2.31301;
431	1.89816	2.3543;
450	2.06105	2.38008;
472	2.24824	2.38805;
496	2.44683	2.37207;
522	2.65094	2.32952;
551	2.86105	2.25713;
583	3.06826	2.15523;
619	3.26958	2.02398;
661	3.46477	1.86201;
708	3.63984	1.68299;
763	3.79918	1.48824;
826	3.9379	1.29177;
901	4.06156	1.09597;
991	4.1715	0.90896;



];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;