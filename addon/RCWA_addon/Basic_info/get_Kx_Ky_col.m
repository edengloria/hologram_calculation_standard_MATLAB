function [Kx Ky] = get_Kx_Ky_col(NBx,NBy,gambda_x,gambda_y,kx,ky)

% 크기에 해당하는 K_x 와 K_y 를 만든다


% NB_x, NB_y 로부터, index 를 정하여 range_ 에 저장한다
Mx         = (NBx - 1) / 2;
My         = (NBy - 1) / 2;
range_x     = [-Mx : +Mx];
range_y     = [-My : +My];

% index 를 돌리면서 값을 구할 것이다
for idx_x = 1 : NBx
    for idx_y = 1 : NBy
        Kx(idx_y + NBy*(idx_x-1)) = range_x(idx_x);
        Ky(idx_y + NBy*(idx_x-1)) = range_y(idx_y);
    end;
end;
Kx         = Kx.';
Ky         = Ky.';

% G_ 값을 곱한고 공통적으로 k_ 값을 더한다
Kx = kx + Kx * 2 * pi / gambda_x;
Ky = ky + Ky * 2 * pi / gambda_y;
