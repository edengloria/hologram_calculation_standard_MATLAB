%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=Mo_nk(lambda);

lambda=lambda*10^9;

Au_data=[190.77	0.783	2.3;
191.51	0.7844	2.3135;
192.25	0.7858	2.3281;
193	0.7873	2.3437;
193.75	0.789	2.36;
194.51	0.7909	2.377;
195.28	0.7929	2.3944;
196.05	0.7953	2.4121;
196.83	0.798	2.43;
197.61	0.8011	2.4475;
198.4	0.8046	2.465;
199.2	0.8086	2.4825;
200	0.813	2.5;
200.81	0.8187	2.5175;
201.63	0.8246	2.535;
202.45	0.8304	2.5525;
203.28	0.836	2.57;
204.12	0.8389	2.5865;
204.96	0.8419	2.6034;
205.81	0.8454	2.6211;
206.67	0.85	2.64;
207.53	0.8563	2.6605;
208.4	0.8621	2.6806;
209.28	0.8677	2.7004;
210.17	0.873	2.72;
211.06	0.8783	2.7396;
211.97	0.8836	2.7594;
212.88	0.8892	2.7795;
213.79	0.895	2.8;
214.72	0.9016	2.8216;
215.65	0.9087	2.8438;
216.59	0.9161	2.8666;
217.54	0.924	2.89;
218.5	0.9322	2.9145;
219.47	0.9408	2.9394;
220.44	0.9497	2.9646;
221.43	0.959	2.99;
222.42	0.9682	3.0146;
223.42	0.9779	3.0394;
224.43	0.9885	3.0645;
225.45	1	3.09;
226.48	1.0136	3.117;
227.52	1.0282	3.1444;
228.57	1.0437	3.1721;
229.63	1.06	3.2;
230.7	1.0762	3.2275;
231.78	1.0931	3.255;
232.86	1.111	3.2825;
233.96	1.13	3.31;
235.07	1.1506	3.3375;
236.19	1.1725	3.365;
237.32	1.1956	3.3925;
238.46	1.22	3.42;
239.61	1.2456	3.4483;
240.78	1.2725	3.4763;
241.95	1.3006	3.5036;
243.14	1.33	3.53;
244.33	1.3606	3.554;
245.54	1.3925	3.5769;
246.77	1.4256	3.5988;
248	1.46	3.62;
249.25	1.4968	3.6413;
250.51	1.5344	3.6619;
251.78	1.5723	3.6815;
253.06	1.61	3.7;
254.36	1.6452	3.7165;
255.67	1.68	3.7319;
256.99	1.7148	3.7463;
258.33	1.75	3.76;
259.69	1.7866	3.7738;
261.05	1.8238	3.7869;
262.43	1.8616	3.799;
263.83	1.9	3.81;
265.24	1.9398	3.8186;
266.67	1.98	3.8263;
268.11	2.0202	3.8333;
269.57	2.06	3.84;
271.04	2.0969	3.8483;
272.53	2.1338	3.8563;
274.03	2.1713	3.8636;
275.56	2.21	3.87;
277.09	2.2526	3.8748;
278.65	2.2969	3.8781;
280.23	2.3427	3.8799;
281.82	2.39	3.88;
283.43	2.4397	3.8794;
285.06	2.49	3.8763;
286.71	2.5403	3.87;
288.37	2.59	3.86;
290.06	2.6377	3.8417;
291.76	2.6838	3.82;
293.49	2.728	3.7958;
295.24	2.77	3.77;
297.01	2.8087	3.7479;
298.8	2.845	3.7244;
300.61	2.8788	3.6987;
302.44	2.91	3.67;
304.29	2.9399	3.6313;
306.17	2.9669	3.5906;
308.07	2.9904	3.5496;
310	3.01	3.51;
311.95	3.0225	3.479;
313.92	3.0313	3.4506;
315.92	3.0369	3.4245;
317.95	3.04	3.4;
320	3.0416	3.3745;
322.08	3.0419	3.3506;
324.18	3.0412	3.329;
326.32	3.04	3.31;
328.48	3.0396	3.2969;
330.67	3.0394	3.2863;
332.89	3.0395	3.2775;
335.14	3.04	3.27;
337.41	3.042	3.262;
339.73	3.0444	3.2544;
342.07	3.0471	3.2471;
344.44	3.05	3.24;
346.85	3.0529	3.2321;
349.3	3.0556	3.2244;
351.77	3.058	3.217;
354.29	3.06	3.21;
356.83	3.0605	3.2041;
359.42	3.0606	3.1988;
362.04	3.0604	3.1941;
364.71	3.06	3.19;
367.41	3.0604	3.1866;
370.15	3.0606	3.1838;
372.93	3.0605	3.1816;
375.76	3.06	3.18;
378.63	3.0584	3.1779;
381.54	3.0563	3.1769;
384.5	3.0534	3.1774;
387.5	3.05	3.18;
390.55	3.0444	3.1874;
393.65	3.0388	3.1969;
396.8	3.0338	3.2079;
400	3.03	3.22;
403.25	3.0309	3.2316;
406.56	3.0331	3.2438;
409.92	3.0363	3.2566;
413.33	3.04	3.27;
416.81	3.0417	3.2833;
420.34	3.0438	3.2975;
423.93	3.0464	3.313;
427.59	3.05	3.33;
431.3	3.0556	3.3509;
435.09	3.0625	3.3731;
438.94	3.0706	3.3963;
442.86	3.08	3.42;
446.85	3.0898	3.4421;
450.91	3.1013	3.4644;
455.05	3.1145	3.487;
459.26	3.13	3.51;
463.55	3.1484	3.5337;
467.92	3.1694	3.5581;
472.38	3.1932	3.5835;
476.92	3.22	3.61;
481.55	3.2488	3.6416;
486.27	3.2813	3.6731;
491.09	3.3181	3.703;
496	3.36	3.73;
501.01	3.4138	3.7549;
506.12	3.4713	3.7731;
511.34	3.5306	3.7823;
516.67	3.59	3.78;
522.11	3.6506	3.7507;
527.66	3.7063	3.7106;
533.33	3.7538	3.6627;
539.13	3.79	3.61;
545.05	3.797	3.5523;
551.11	3.7925	3.4969;
557.3	3.7792	3.448;
563.64	3.76	3.41;
570.11	3.7396	3.4057;
576.74	3.7181	3.4131;
583.53	3.6976	3.429;
590.48	3.68	3.45;
597.59	3.6733	3.4663;
604.88	3.6713	3.4838;
612.35	3.6736	3.5019;
620	3.68	3.52;
627.85	3.6913	3.5379;
635.9	3.7056	3.5544;
644.16	3.7221	3.5687;
652.63	3.74	3.58;
661.33	3.7585	3.586;
670.27	3.7769	3.5881;
679.45	3.7943	3.5862;
688.89	3.81	3.58;
698.59	3.8236	3.5675;
708.57	3.8338	3.5513;
718.84	3.8395	3.5319;
729.41	3.84	3.51;
740.3	3.8346	3.487;
751.52	3.8219	3.4625;
763.08	3.8007	3.4367;
775	3.77	3.41;
787.3	3.7248	3.3748;
800	3.6694	3.3425;
813.11	3.6043	3.3164;
826.67	3.53	3.3;
840.68	3.4427	3.3041;
855.17	3.3488	3.3219;
870.18	3.2505	3.3537;
885.71	3.15	3.4;
901.82	3.053	3.4664;
918.52	2.9569	3.5463;
935.85	2.8623	3.638;
953.85	2.77	3.74;
972.55	2.6828	3.8465;
992	2.5988	3.9619;
1012.24	2.5178	4.0863;
1033.33	2.44	4.22;
1055.32	2.3649	4.3654;
1078.26	2.2931	4.5194;
1102.22	2.2248	4.6812;
1127.27	2.16	4.85;
1153.49	2.099	5.0251;
1180.95	2.0419	5.2056;
1209.76	1.9888	5.3909;
1240	1.94	5.58;
1271.79	1.8864	5.7839;
1305.26	1.8324	6.0022;
1340.54	1.7822	6.2343;
1377.78	1.74	6.48;
1417.14	1.7158	6.7388;
1458.82	1.6853	7.0097;
1503.03	1.6472	7.2921;
1550	1.6213	7.5838;
1600	1.5905	7.8951;
1653.33	1.5394	8.2365;
1710.34	1.503	8.6012;
1771.43	1.48	8.99;
1837.04	1.4493	9.4081;
1907.69	1.4171	9.8431;
1984	1.3859	10.3019;
2066.67	1.3563	10.8269;
2156.52	1.3393	11.4307;
2254.55	1.345	12.1172;
2361.9	1.3585	12.8232;
2480	1.37	13.5;
];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;