%%% VO2 n, k 
% - metal mode
% - lambda : 320nm ~ 1000nm
% - Using Lagrange interpolation

function result=VO2_metal_nk(lambda);

lambda=lambda*10^9;

VO2_metal_data_real=[320.13 -0.329808;
323.884 -0.38779;
326.552 -0.480271;
328.681 -0.572707;
330.275 -0.653564;
346.827 -1.18544;
352.21 -1.1859;
355.997 -1.11704;
358.174 -1.02498;
360.348 -0.944449;
361.99 -0.840809;
365.241 -0.76037;
366.443 -0.276157;
368.082 -0.184048;
369.724 -0.0804074;
372.059 0.622804;
372.433 -0.0114535;
374.075 0.0921868;
374.236 0.714867;
375.714 0.184296;
375.875 0.806976;
378.049 0.887507;
378.763 1.5678;
379.867 1.67148;
380.226 0.97957;
381.33 1.08326;
381.506 1.76359;
384.397 2.53594;
384.751 1.82097;
386.036 2.62805;
386.392 1.92461;
387.139 2.73174;
387.496 2.0283;
387.856 3.42356;
388.96 3.52725;
390.063 3.63093;
390.384 2.78912;
392.026 2.89276;
392.408 4.36874;
393.13 2.99644;
393.308 3.68831;
394.046 4.46085;
395.483 3.76884;
395.688 4.56449;
396.048 3.87257;
398.398 4.63344;
399.115 5.32526;
400.04 4.73708;
400.754 5.41737;
401.679 4.82919;
402.396 5.52101;
404.728 6.21269;
405.644 5.58992;
406.367 6.3048;
406.747 5.6936;
407.851 5.79729;
408.544 6.39686;
410.718 6.47739;
412.36 6.58103;
413.583 7.14597;
414.537 6.6731;
415.76 7.23803;
418.47 7.30698;
420.647 7.39904;
422.289 7.50268;
423.928 7.59479;
426.64 7.67528;
433.205 8.07831;
438.056 8.10095;
442.91 8.13513;
447.764 8.1693;
453.147 8.16884;
457.998 8.19148;
463.388 8.21408;
477.421 8.35124;
482.807 8.3623;
487.658 8.38495;
493.041 8.38448;
497.881 8.361;
502.714 8.31446;
507.556 8.30251;
520.384 7.94392;
525.22 7.90891;
528.432 7.83945;
532.183 7.76993;
534.857 7.70051;
538.066 7.61952;
541.278 7.55005;
544.49 7.48058;
548.779 7.41103;
562.131 6.99474;
566.967 6.95973;
569.638 6.87878;
572.85 6.80931;
576.6 6.7398;
579.813 6.67033;
583.563 6.60082;
586.775 6.53136;
591.608 6.48481;
604.975 6.12618;
609.811 6.09117;
613.561 6.02166;
617.312 5.95215;
620.524 5.88268;
624.275 5.81317;
627.487 5.7437;
631.776 5.67414;
636.077 5.65071;
647.834 5.31528;
652.676 5.30333;
656.968 5.2453;
660.718 5.17579;
665.01 5.11776;
668.764 5.05978;
673.053 4.99022;
676.265 4.92076;
691.802 4.63113;
696.1 4.59616;
700.93 4.53809;
704.684 4.48011;
708.437 4.42213;
712.729 4.3641;
716.483 4.30612;
720.236 4.24813;
734.706 3.99319;
739.545 3.96971;
743.834 3.90015;
747.585 3.83064;
751.338 3.77266;
755.089 3.70315;
759.922 3.6566;
764.752 3.59853;
778.681 3.3321;
783.523 3.32015;
788.353 3.26208;
791.568 3.20414;
795.86 3.14611;
799.614 3.08813;
803.905 3.03011;
808.197 2.97208;
824.818 2.70542;
829.654 2.67041;
833.946 2.61238;
838.24 2.56588;
842.532 2.50785;
846.824 2.44982;
851.116 2.3918;
855.958 2.37985;
867.727 2.09054;
872.569 2.07859;
876.861 2.02057;
881.694 1.97402;
885.983 1.90446;
890.275 1.84644;
894.567 1.78841;
911.729 1.53323;
916.565 1.49822;
920.86 1.45172;
925.152 1.3937;
929.443 1.33567;
933.735 1.27764;
938.027 1.21961;
942.863 1.1846;
954.647 0.952954;
959.489 0.941004;
963.778 0.871444;
968.612 0.824901;
973.442 0.766826;
977.195 0.708845;
980.946 0.639332;
985.782 0.60432;
998.646 0.384112;
1003.48 0.36063;
1007.78 0.302602;
1012.07 0.244574;
1016.36 0.186546;
1021.19 0.128472;
1025.49 0.0819748;
1029.79 0.0585402;
1042.64 -0.184731;
1047.48 -0.208212;
1051.78 -0.254709;
1056.07 -0.312737;
1060.36 -0.370765;
1065.19 -0.428839;
1069.48 -0.486867;
1074.32 -0.510349;
1085.57 -0.730417;
1090.42 -0.730836;
1094.71 -0.788864;
1098.46 -0.858377;
1102.75 -0.916405;
1107.04 -0.974433;
1111.33 -1.03246;
1116.17 -1.05594;
1129.58 -1.2762;
1134.42 -1.29968;
1138.7 -1.36924;
1143.53 -1.42731;
1147.83 -1.47381;
1152.12 -1.52031;
1155.88 -1.57829;
1160.72 -1.60177;
1172.5 -1.82188;
1177.88 -1.83388;
1182.18 -1.89191;
1186.47 -1.94994;
1190.76 -2.00796;
1195.59 -2.05451;
1199.89 -2.10101;
1216.51 -2.36766;
1221.89 -2.37966;
1226.18 -2.42616;
1229.94 -2.48414;
1234.77 -2.54221;
1239.06 -2.60024;
1243.35 -2.64674;
1259.44 -2.87876;
1264.83 -2.89075;
1269.12 -2.93725;
1272.87 -2.99523;
1277.17 -3.05326;
1280.92 -3.09971;
1285.75 -3.14625;
1290.59 -3.18127;
1302.39 -3.36679;
1307.76 -3.39032;
1312.59 -3.44839;
1316.89 -3.49489;
1321.18 -3.55292;
1325.48 -3.58788;
1329.77 -3.64591;
1346.39 -3.90104;
1351.77 -3.91303;
1355.53 -3.95948;
1359.83 -4.00598;
1363.58 -4.05243;
1368.42 -4.08744;
1372.71 -4.14547;
1377.55 -4.18048;
1389.34 -4.37754;
1394.18 -4.40102;
1397.94 -4.44747;
1402.77 -4.48248;
1407.06 -4.54051;
1411.36 -4.58701;
1415.65 -4.6335;
1421.03 -4.66856;
1433.36 -4.86566;
1438.2 -4.88914;
1443.03 -4.93569;
1447.32 -4.99371;
1451.62 -5.04021;
1456.45 -5.07522;
1460.75 -5.13325;
1477.38 -5.34226;
1482.22 -5.36574;
1486.52 -5.4007;
1490.81 -5.45873;
1495.64 -5.50527;
1500.47 -5.56335;
1504.23 -5.6098;
1520.33 -5.81876;
1524.63 -5.84219;
1529.47 -5.86567;
1533.22 -5.92365;
1538.05 -5.9702;
1542.35 -6.01669;
1547.18 -6.06324;
1564.35 -6.28382;
1569.2 -6.28424;
1573.49 -6.34226;
1578.32 -6.38881;
1582.62 -6.4353;
1586.91 -6.47027;
1591.21 -6.5283;
1607.31 -6.71419;
1612.15 -6.72614;
1616.98 -6.78422;
1620.74 -6.83067;
1625.03 -6.87716;
1629.87 -6.91218;
1634.16 -6.95867;
1651.34 -7.16772;
1656.18 -7.17967;
1660.48 -7.21464;
1665.31 -7.26118;
1669.07 -7.30763;
1673.9 -7.35418;
1678.2 -7.40067;
1683.03 -7.42416;
1695.37 -7.59819;
1700.21 -7.62167;
1705.05 -7.65669;
1709.34 -7.70318;
1714.18 -7.72666;
1718.48 -7.77316;
1723.31 -7.80817;
1737.26 -7.99388;
1742.1 -8.01736;
1746.4 -8.05233;
1751.23 -8.08734;
1756.07 -8.13389;
1760.36 -8.19191;
1764.66 -8.22688;
1780.23 -8.38966;
1785.07 -8.40161;
1789.36 -8.44811;
1794.2 -8.49466;
1798.49 -8.54115;
1803.87 -8.56468;
1808.7 -8.61122;
1823.19 -8.79698;
1828.57 -8.80897;
1832.87 -8.84394;
1837.7 -8.89048;
1842 -8.92545;
1846.3 -8.97195;
1850.59 -9.00691;
1867.24 -9.16979;
1871.54 -9.19323;
1875.84 -9.23972;
1880.67 -9.2632;
1885.51 -9.30975;
1889.81 -9.34471;
1894.64 -9.37973;
1911.29 -9.5426;
1916.13 -9.56609;
1920.96 -9.6011;
1925.26 -9.63606;
1929.02 -9.68251;
1933.85 -9.72906;
1938.15 -9.75249;
1955.34 -9.92695;
1960.72 -9.93895;
1964.47 -9.9854;
1969.85 -10.0089;
1973.61 -10.0554;
1978.45 -10.0789;
1982.74 -10.1254;     
    ];

VO2_metal_data_image = [304.788 1.91009; 
304.85 2.47912;
306.413 1.98476;
309.117 2.05945;
310.24 2.47925;
311.28 2.1248;
314.557 2.51666;
316.181 2.582;
318.346 2.65668;
319.972 2.74067;
322.136 2.81535;
322.181 3.2258;
324.301 2.89003;
324.345 3.30047;
325.97 3.37514;
328.134 3.44049;
329.76 3.52448;
330.891 4.00958;
331.924 3.59916;
333.055 4.08426;
334.142 4.16824;
337.383 4.22429;
337.44 4.756;
339.008 4.29895;
339.065 4.83067;
340.634 4.38294;
340.692 4.91466;
342.912 5.51173;
343.931 4.96138;
344.538 5.58639;
345.018 5.04536;
345.625 5.67037;
346.106 5.12934;
348.864 5.71709;
349.468 6.31412;
350.491 5.80108;
350.555 6.3981;
351.578 5.88506;
352.718 6.46345;
352.778 7.01382;
354.403 7.08849;
355.958 6.51017;
356.029 7.17248;
357.045 6.59415;
358.249 7.76022;
358.731 7.22852;
359.874 7.83489;
360.895 7.30319;
360.962 7.91887;
361.982 7.38717;
363.728 8.58124;
364.202 7.97491;
364.816 8.66522;
365.827 8.04958;
366.915 8.13356;
367.518 8.73059;
370.22 8.78662;
371.307 8.8706;
373.59 10.046;
375.754 10.1207;
377.38 10.1954;
379.543 10.2607;
381.169 10.3447;
383.334 10.4194;
384.45 10.7739;
389.305 10.802;
408.074 9.88825;
410.222 9.81367;
411.832 9.73908;
415.543 9.16081;
417.152 9.08622;
418.76 9.0023;
421.929 8.39603;
423.539 8.32144;
425.687 8.24687;
428.86 7.67791;
431.008 7.60334;
433.158 7.53809;
433.651 7.10899;
434.766 7.45417;
436.339 7.04376;
438.488 6.97851;
440.096 6.89459;
441.706 6.82;
443.854 6.74543;
446.508 6.36302;
449.737 6.30713;
452.425 6.24189;
454.033 6.15798;
455.642 6.08339;
457.792 6.01814;
461.019 5.95292;
463.678 5.61716;
467.447 5.5706;
470.134 5.49604;
471.744 5.42145;
473.892 5.34687;
475.501 5.27228;
478.189 5.20705;
481.924 4.84333;
485.152 4.78743;
487.841 4.7222;
489.449 4.63828;
491.058 4.56369;
493.746 4.49845;
496.435 4.43322;
499.095 4.10679;
502.864 4.06023;
505.012 3.98566;
507.16 3.91108;
509.309 3.8365;
511.458 3.77126;
514.145 3.69669;
521.655 3.35172;
525.964 3.3145;
528.652 3.24927;
531.881 3.19337;
534.568 3.11881;
537.797 3.06292;
540.485 2.99768;
543.713 2.94178;
548.562 2.91391;
562.006 2.60639;
566.317 2.58783;
571.163 2.54131;
576.012 2.51343;
580.86 2.47623;
585.709 2.44836;
590.556 2.41116;
592.706 2.34591;
598.095 2.32738;
602.944 2.30884;
618.586 2.38383;
623.977 2.38395;
629.367 2.37475;
634.756 2.36555;
648.774 2.3752;
654.164 2.37533;
659.017 2.38477;
664.41 2.40355;
669.801 2.40368;
675.193 2.41313;
680.045 2.41325;
691.911 2.47882;
696.763 2.47894;
702.156 2.49772;
707.549 2.5165;
712.403 2.53527;
717.796 2.55405;
722.648 2.56349;
736.135 2.64776;
741.526 2.65722;
746.381 2.68532;
751.236 2.71342;
755.552 2.7415;
760.945 2.76028;
765.799 2.78838;
777.131 2.89126;
782.522 2.89138;
786.838 2.91947;
791.692 2.94757;
796.008 2.97565;
800.325 3.01307;
805.179 3.03184;
821.367 3.18147;
826.759 3.19092;
831.076 3.22834;
835.931 3.25643;
840.785 3.28453;
844.563 3.32193;
849.418 3.35003;
864.528 3.49964;
869.92 3.50909;
873.698 3.54649;
878.554 3.58392;
882.87 3.62134;
887.187 3.65875;
892.043 3.69618;
908.772 3.86448;
913.626 3.88325;
919.021 3.92069;
922.8 3.96742;
927.117 4.01416;
931.434 4.05157;
935.751 4.08899;
953.023 4.28529;
957.877 4.31338;
962.193 4.34147;
966.51 4.37888;
971.366 4.41631;
975.684 4.47238;
980.002 4.51912;
997.274 4.71542;
1002.13 4.73419;
1006.98 4.78095;
1011.3 4.83702;
1016.16 4.87444;
1020.48 4.92119;
1024.79 4.96793;
1040.45 5.19217;
1045.31 5.21094;
1049.62 5.25769;
1054.48 5.30444;
1058.8 5.35118;
1062.58 5.38859;
1066.36 5.45397;
1070.67 5.47273;
1084.71 5.69694;
1089.57 5.71571;
1093.88 5.76245;
1097.66 5.81851;
1101.44 5.86524;
1106.84 5.90268;
1111.15 5.94942;
1115.47 5.97751;
1128.97 6.22969;
1133.83 6.24846;
1138.15 6.2952;
1141.92 6.34193;
1145.7 6.38866;
1150.02 6.4354;
1153.8 6.49146;
1158.66 6.52889;
1172.16 6.77174;
1177.01 6.79051;
1181.33 6.83725;
1185.65 6.88399;
1188.89 6.94004;
1192.67 6.9961;
1196.45 7.04283;
1200.76 7.08957;
1216.42 7.3418;
1221.28 7.36057;
1225.06 7.41663;
1228.84 7.47269;
1232.62 7.51942;
1236.39 7.55682;
1240.17 7.62221;
1243.95 7.66894;
1257.46 7.90246;
1262.31 7.92123;
1266.09 7.98662;
1269.87 8.02402;
1273.65 8.08008;
1277.43 8.13613;
1281.21 8.19219;
1285.52 8.23893;
1301.73 8.50984;
1306.04 8.54725;
1309.82 8.59398;
1313.6 8.65004;
1316.84 8.70608;
1320.62 8.76214;
1324.4 8.80887;
1328.18 8.8556;
1333.03 8.8837;
1344.92 9.14517;
1349.78 9.17327;
1353.56 9.23866;
1357.33 9.27606;
1360.57 9.3321;
1364.36 9.39749;
1367.6 9.45354;
1371.38 9.50959;
1388.12 9.79916;
1392.97 9.82726;
1396.75 9.88332;
1399.99 9.93937;
1403.77 9.9861;
1407.55 10.0515;
1410.79 10.1075;
1414.03 10.1636;
1418.35 10.2103;
1432.4 10.4718;
1437.25 10.4999;
1441.03 10.5653;
1444.27 10.6214;
1448.05 10.6681;
1451.29 10.7241;
1455.07 10.7895;
1458.31 10.8456;
1463.17 10.8737;
1475.6 11.1538;
1480.45 11.1912;
1484.23 11.2473;
1488.01 11.3034;
1491.25 11.3594;
1495.03 11.4155;
1498.27 11.4715;
1502.05 11.5276;
1517.72 11.8638;
1522.57 11.8825;
1526.35 11.9386;
1529.6 11.9946;
1533.37 12.0414;
1537.15 12.1067;
1540.39 12.1628;
1543.64 12.2188;
1547.95 12.2656;
1562 12.5831;
1566.86 12.6018;
1570.64 12.6672;
1573.88 12.7233;
1577.12 12.7793;
1580.9 12.8354;
1584.14 12.8914;
1587.92 12.9475;
1592.24 12.9849;
1605.21 13.3024;
1609.52 13.3398;
1613.3 13.3958;
1617.08 13.4519;
1620.32 13.5079;
1624.1 13.564;
1627.34 13.62;
1630.59 13.6761;
1634.36 13.7228;
1647.34 14.0403;
1652.19 14.0684;
1655.97 14.1244;
1659.75 14.1805;
1662.99 14.2365;
1666.23 14.2926;
1670.01 14.358;
1673.25 14.414;
1677.57 14.4608;
1690.54 14.7782;
1694.86 14.8063;
1698.64 14.8624;
1701.88 14.9184;
1705.66 14.9745;
1708.9 15.0305;
1712.14 15.0959;
1715.38 15.1519;
1719.16 15.1987;
1734.83 15.5349;
1739.68 15.563;
1742.92 15.6283;
1745.63 15.6937;
1748.87 15.7497;
1752.65 15.8058;
1755.35 15.8712;
1758.59 15.9272;
1761.83 15.9926;
1766.15 16.03;
1779.12 16.3475;
1783.98 16.3756;
1787.22 16.4316;
1790.46 16.4877;
1793.7 16.553;
1796.94 16.6091;
1800.18 16.6651;
1803.42 16.7305;
1807.2 16.7865;
1821.25 17.104;
1826.11 17.1321;
1829.35 17.1975;
1832.59 17.2536;
1835.29 17.3189;
1838.53 17.3843;
1841.77 17.4403;
1845.01 17.4964;
1849.33 17.5431;
1862.3 17.8606;
1866.62 17.898;
1870.4 17.9447;
1874.18 18.0008;
1876.88 18.0662;
1880.12 18.1222;
1882.82 18.1876;
1886.07 18.2529;
1890.38 18.2997;
1903.35 18.6171;
1908.21 18.6452;
1911.45 18.7106;
1914.69 18.7667;
1917.39 18.832;
1921.17 18.8881;
1924.41 18.9441;
1927.12 19.0095;
1931.97 19.0562;
1944.41 19.3737;
1948.72 19.4111;
1951.97 19.4765;
1955.21 19.5325;
1958.45 19.5979;
1961.69 19.654;
1964.93 19.71;
1968.71 19.7661;
1973.03 19.8128;
1984.38 20.1302;
1988.7 20.1676;
1991.94 20.233;
1995.18 20.2891;];

this_data = VO2_metal_data_real ;
that_data = VO2_metal_data_image ;
if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end
if min(lambda) < that_data(1,1) || max(lambda) > that_data(end,1)
    warning(['Out of valid range (' num2str(that_data(1,1)) ' ~ ' num2str(that_data(end,1)) ' nm)']);
end
in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
in_range2 = (that_data(1,1) <= lambda).*(lambda <= that_data(end,1)) ;
ep_real = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
ep_image = in_range.*(interp1(that_data(:,1), that_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(that_data(:,1), that_data(:,2), lambda, 'linear')) ;

result=sqrt(ep_real+i*ep_image);