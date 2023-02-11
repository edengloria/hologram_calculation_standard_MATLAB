%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=Al_ETRI_nk(lambda);

lambda=lambda*10^9;

Au_data=[47.7	0.838	0.0159;
51.6	0.785	0.0182;
56.3	0.718	0.0213;
62	0.635	0.0267;
65.2	0.58	0.0307;
68.9	0.52	0.0355;
72.9	0.445	0.0424;
77.5	0.345	0.0632;
82.6	0.225	0.22;
92	0.104	0.39;
103.2	0.033	0.58;
120	0.057	1.15;
140	0.065	1.43;
160	0.08	1.73;
180	0.095	1.97;
200	0.11	2.2;
220	0.13	2.4;
240	0.16	2.53;
260	0.19	2.85;
280	0.22	3.13;
300	0.25	3.33;
320	0.28	3.56;
340	0.31	3.8;
360	0.34	4.01;
380	0.37	4.25;
400	0.4	4.45;
436	0.47	4.84;
450	0.51	5;
492	0.64	5.5;
546	0.82	5.99;
578	0.93	6.33;
650	1.3	7.11;
700	1.55	7;
750	1.8	7.12;
800	1.99	7.05;
850	2.08	7.15;
900	1.96	7.7;
950	1.75	8.5;
2000	2.3	16.5;
4000	6.1	30.4;
6000	10.8	42.6;
8000	17.9	55.3;
10000	26	67.3;
12000	33.1	78.00002;
];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;