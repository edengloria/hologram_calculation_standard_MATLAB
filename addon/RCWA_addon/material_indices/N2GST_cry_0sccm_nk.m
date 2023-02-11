%%% Au의 n, k값 구하는 함수 %%%
%   - lambda : 100nm ~ 9919nm
%   - Using Lagrange interpolation


function result=GST_cry_0sccm_nk(lambda);

lambda=lambda*10^9;

Au_data=[
    
280 	1.073081 	1.974599; 
290 	1.128478 	2.069944;
300 	1.186434 	2.161879;
310 	1.246881 	2.250692;
320 	1.309594 	2.336363;
330 	1.374430 	2.418955; 
340 	1.441400 	2.498672;
350 	1.510278 	2.575404;
360 	1.581017 	2.649237;
370 	1.653546 	2.720207;
380 	1.727681 	2.788230;
390 	1.803389 	2.853366;
400 	1.880587 	2.915617;
410 	1.959163 	2.974956;
420 	2.038903 	3.031293;
430 	2.119915 	3.084760;
440 	2.201936 	3.135238;
450 	2.284872 	3.182726;
460 	2.368625 	3.227226;
470 	2.453099 	3.268740;
480 	2.538171 	3.307261;
490 	2.623758 	3.342804;
500 	2.709636 	3.375333;
510 	2.795717 	3.404877;
520 	2.881921 	3.431468;
530 	2.968146 	3.455133;
540 	3.054184 	3.475878;
550 	3.139954 	3.493752;
560 	3.225408 	3.508809;
570 	3.310345 	3.521080;
580 	3.394675 	3.530627;
590 	3.478257 	3.537507;
600 	3.561119 	3.541795;
610 	3.643045 	3.543553;
620 	3.723880 	3.542861;
630 	3.803693 	3.539799;
640 	3.882359 	3.534448;
650 	3.959746 	3.526901;
660 	4.035868 	3.517237;
670 	4.110523 	3.505569;
680 	4.183770 	3.491975;
690 	4.255591 	3.476541;
700 	4.325801 	3.459394;
710 	4.394473 	3.440606;
720 	4.461562 	3.420273;
730 	4.526993 	3.398508;
740 	4.590810 	3.375382;
750 	4.652941 	3.351011;
760 	4.713406 	3.325474;
770 	4.772188 	3.298866;
780 	4.829289 	3.271273;
790 	4.884756 	3.242759;
800 	4.938542 	3.213432;
810 	4.990715 	3.183341;
820 	5.041183 	3.152622;
830 	5.090088 	3.121276;
840 	5.137398 	3.089404;
850 	5.183120 	3.057085;
860 	5.227326 	3.024346;
870 	5.269995 	2.991284;
880 	5.311193 	2.957929;
890 	5.350937 	2.924340;
900 	5.389270 	2.890561;
910 	5.426174 	2.856685;
920 	5.461762 	2.822680;
930 	5.496015 	2.788640;
940 	5.528988 	2.754580;
950 	5.560704 	2.720550;
960 	5.591216 	2.686563;
970 	5.620529 	2.652680;
980 	5.648690 	2.618918;
990 	5.675753 	2.585280;
1000 	5.701732 	2.551813;
1010 	5.726667 	2.518528;
1020 	5.750593 	2.485446;
1030 	5.773510 	2.452709;

];


this_data = Au_data ;

if min(lambda) < this_data(1,1) || max(lambda) > this_data(end,1)
    warning(['Out of valid range (' num2str(this_data(1,1)) ' ~ ' num2str(this_data(end,1)) ' nm)']);
end

in_range = (this_data(1,1) <= lambda).*(lambda <= this_data(end,1)) ;
n = in_range.*(interp1(this_data(:,1), this_data(:,2), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,2), lambda, 'linear')) ;
k = in_range.*(interp1(this_data(:,1), this_data(:,3), lambda, 'spline'))+(1-in_range).*(interp1(this_data(:,1), this_data(:,3), lambda, 'linear')) ;

result=n+j*k;