function [Kx] = get_Kx_col(NBx,gambda_x,kx)

% 크기에 해당하는 K_x 를 만든다
% NB_x 로부터, index 를 정하여 range_ 에 저장한다
Mx         = (NBx - 1) / 2;
Kx         = [-Mx : +Mx];

Kx         = Kx.';

% G_ 값을 곱한고 공통적으로 k_ 값을 더한다
Kx = kx + Kx * 2 * pi / gambda_x;
