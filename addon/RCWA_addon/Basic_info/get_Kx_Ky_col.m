function [Kx Ky] = get_Kx_Ky_col(NBx,NBy,gambda_x,gambda_y,kx,ky)

% ũ�⿡ �ش��ϴ� K_x �� K_y �� �����


% NB_x, NB_y �κ���, index �� ���Ͽ� range_ �� �����Ѵ�
Mx         = (NBx - 1) / 2;
My         = (NBy - 1) / 2;
range_x     = [-Mx : +Mx];
range_y     = [-My : +My];

% index �� �����鼭 ���� ���� ���̴�
for idx_x = 1 : NBx
    for idx_y = 1 : NBy
        Kx(idx_y + NBy*(idx_x-1)) = range_x(idx_x);
        Ky(idx_y + NBy*(idx_x-1)) = range_y(idx_y);
    end;
end;
Kx         = Kx.';
Ky         = Ky.';

% G_ ���� ���Ѱ� ���������� k_ ���� ���Ѵ�
Kx = kx + Kx * 2 * pi / gambda_x;
Ky = ky + Ky * 2 * pi / gambda_y;
