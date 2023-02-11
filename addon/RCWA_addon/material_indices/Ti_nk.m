%%% Ag�� n, k�� ���ϴ� �Լ� %%%


% �ۼ��� : ������
% �ۼ��� : 2008.9.16
% �������� : J. Appl. Phys., vol. 94, no. 2, 15 Jul 2003.  Paulson, Birkmire and Shafarman
%
% c0=3e8;
% hbar=6.582e-16;
% 
% e_=fliplr([(0.75:0.05:1.95) (2.00:0.1:4.60)]).';
% w_=1/hbar*e_;
% l_=2*pi*c0./w_;
% ln_=l_*1e9;
% 

function result=CIGS_nk(lambda);

lambda=lambda*10^9;



CIGS_data=[ 208.38	1.1675	1.21625
210.14	1.18	1.22
211.94	1.195	1.22125
213.77	1.21	1.22
215.63	1.22125	1.215
217.52	1.23	1.21
219.44	1.23625	1.21063
221.4	1.24	1.21
223.4	1.24438	1.2025
225.43	1.24	1.19
227.5	1.19938	1.165
229.6	1.18	1.15
231.75	1.26688	1.17813
233.93	1.35	1.21
236.16	1.31625	1.20875
238.43	1.26	1.2
240.75	1.25	1.19875
243.11	1.25	1.2
245.52	1.24563	1.20438
247.97	1.24	1.21
250.48	1.23	1.215
253.03	1.22	1.22
255.64	1.21563	1.22438
258.3	1.21	1.23
261.02	1.195	1.23875
263.8	1.18	1.25
266.64	1.17438	1.26438
269.53	1.17	1.28
272.5	1.16062	1.29562
275.52	1.15	1.31
278.62	1.14062	1.31938
281.78	1.13	1.33
285.02	1.11687	1.34688
288.34	1.1	1.37
291.73	1.07375	1.40187
295.2	1.05	1.44
298.76	1.04187	1.48437
302.4	1.04	1.53
306.14	1.03812	1.56813
309.96	1.04	1.61
313.89	1.04687	1.66875
317.91	1.06	1.73
322.04	1.0825	1.78313
326.28	1.11	1.83
330.63	1.13875	1.8675
335.1	1.17	1.9
339.69	1.205	1.93125
344.4	1.24	1.96
349.25	1.27	1.98562
354.24	1.3	2.01
359.38	1.33437	2.03625
364.66	1.37	2.06
370.11	1.40563	2.07625
375.71	1.44	2.09
381.49	1.47125	2.105
387.45	1.5	2.12
393.6	1.52625	2.13562
399.95	1.55	2.15
406.51	1.57063	2.15938
413.28	1.59	2.17
420.29	1.60937	2.18875
427.54	1.63	2.21
435.04	1.65563	2.23
442.8	1.68	2.25
450.86	1.69562	2.26937
459.21	1.71	2.29
467.87	1.73	2.31437
476.87	1.75	2.34
486.22	1.76562	2.36312
495.94	1.78	2.39
506.06	1.79375	2.4275
516.61	1.81	2.47
527.6	1.83312	2.51313
539.07	1.86	2.56
551.05	1.8875	2.61438
563.57	1.92	2.67
576.68	1.9625	2.72
590.41	2.01	2.77
604.81	2.05875	2.82437
619.93	2.11	2.88
635.82	2.1625	2.93438
652.55	2.22	2.99
670.19	2.28562	3.04937
688.81	2.36	3.11
708.49	2.44625	3.17312
729.33	2.54	3.23
751.43	2.63625	3.27125
774.91	2.74	3.3
799.91	2.86063	3.31687
826.57	2.98	3.32
855.07	3.08312	3.30312
885.61	3.17	3.28
918.41	3.2325	3.25938
953.73	3.28	3.25
991.88	3.31438	3.26687
1033.21	3.35	3.3
1078.13	3.405	3.34562
1127.14	3.47	3.4
1180.81	3.5425	3.45938
1239.85	3.62	3.52
];
        

this_data = CIGS_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;