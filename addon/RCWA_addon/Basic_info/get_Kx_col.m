function [Kx] = get_Kx_col(NBx,gambda_x,kx)

% ũ�⿡ �ش��ϴ� K_x �� �����
% NB_x �κ���, index �� ���Ͽ� range_ �� �����Ѵ�
Mx         = (NBx - 1) / 2;
Kx         = [-Mx : +Mx];

Kx         = Kx.';

% G_ ���� ���Ѱ� ���������� k_ ���� ���Ѵ�
Kx = kx + Kx * 2 * pi / gambda_x;
