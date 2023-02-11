function h = hot_lsy(m)
%HOT    Black-red-yellow-white color map
%   HOT(M) returns an M-by-3 matrix containing a "hot" colormap.
%   HOT, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(hot)
%
%   See also HSV, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT.

%   C. Moler, 8-17-88, 5-11-91, 8-19-92.
%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 5.7.4.2 $  $Date: 2005/06/21 19:30:30 $

if nargin < 1, m = size(get(gcf,'colormap'),1); end
n = fix(3/8*m);

r = [1.00000000000000;0.999999999999962;0.999999999998546;0.999999999980635;0.999999999855720;0.999999999255549;0.999999997019033;0.999999990085184;0.999999971380808;0.999999926128864;0.999999825815734;0.999999618841222;0.999999216633861;0.999998473746109;0.999997160149294;0.999994923626877;0.999991239816879;0.999985347080672;0.999976162976376;0.999962178692148;0.999941327349694;0.999910821624601;0.999866955652824;0.999804865709531;0.999718243669360;0.999598996803080;0.999436847059482;0.999218862658100;0.998928914627034;0.998547050927886;0.998048781107476;0.997404265124799;0.996577401280820;0.995524810233984;0.994194715177920;0.992525722716894;0.990445515199801;0.987869473742865;0.984699262437813;0.980821418919987;0.976106015201404;0.970405476066232;0.963553670855483;0.955365428318885;0.945636663051345;0.934145344689764;0.920653585100420;0.904911160041753;0.886660813678747;0.865645707316211;0.841619354816220;0.814358319783033;0.783677814106169;0.749450112875091;0.711625368117017;0.670253952127652;0.625508895307409;0.577706335118510;0.527321232369893;0.474995057345138;0.421531871529575;0.367879441171442;0.315092933567333;0.264280528051061;];
g = [0.999976676656833;0.999813428485347;0.999370460633783;0.998508402169222;0.997088793907686;0.994974768064095;0.992031914837061;0.988129328052611;0.983140818330969;0.976946277985140;0.969433177112107;0.960498165232024;0.950048747536902;0.938004999530730;0.924301278811736;0.908887888225287;0.891732640882217;0.872822274880471;0.852163664271788;0.829784773144222;0.805735301873480;0.780086978804652;0.752933456961675;0.724389783856088;0.694591422987468;0.663692817989802;0.631865504257791;0.599295787845538;0.566182026922248;0.532731566462469;0.499157391446822;0.465674576929205;0.432496624174522;0.399831780027075;0.367879441171442;0.336826745572784;0.306845449886979;0.278089183973457;0.250691162008346;0.224762414491818;0.200390587293775;0.177639333595135;0.156548303109860;0.137133711357267;0.119389451062513;0.103288689022283;0.0887858759019362;0.0758190841818574;0.0643125813803088;0.0541795420336448;0.0453248027326881;0.0376475695552070;0.0310439960190059;0.0254095615298582;0.0206411943901503;0.0166390988617236;0.0133082616170276;0.0105596282896618;0.00831095497439647;0.00648735180029923;0.00502154565779214;0.00385389654096720;0.00293220669850158;0.00221136397053098;];
b = [0.999000499833375;0.992031914837061;0.973361241524337;0.938004999530730;0.882496902584596;0.805735301873480;0.709638211560209;0.599295787845538;0.482391140115126;0.367879441171442;0.264212916233086;0.177639333595135;0.111136066950622;0.0643125813803088;0.0342181183116660;0.0166390988617236;0.00735040400942007;0.00293220669850158;0.00104996337119225;0.000335462627902512;9.50602173814042e-05;2.37482907142475e-05;5.19923010535949e-06;9.91546491520138e-07;1.63737713059081e-07;2.32723471220045e-08;2.82996922474161e-09;2.92662806700201e-10;2.55853805457153e-11;1.87952881653908e-12;1.15327556260789e-13;5.87541323195481e-15;2.47035406841917e-16;8.52098269426713e-18;2.39675746327996e-19;5.46457828903352e-21;1.00387955192341e-22;1.47704317084161e-24;1.73015745331518e-26;1.60381089054864e-28;1.16947249693379e-30;6.66792067737672e-33;2.95493973023827e-35;1.01171654805693e-37;2.66020641594399e-40;5.33964407828380e-43;8.13287327698493e-46;9.34339388019506e-49;8.04800983734170e-52;5.16642063283786e-55;2.45698599542400e-58;8.60441777069705e-62;2.20566939783770e-65;4.11389972394639e-69;5.54952194806860e-73;5.38195752669830e-77;3.72994143521489e-81;1.83626369110894e-85;6.38312870294040e-90;1.55737037429695e-94;2.65096627711832e-99;3.12942621977178e-104;2.54664074641954e-109;1.42006209754307e-114;];
h = [r g b];
