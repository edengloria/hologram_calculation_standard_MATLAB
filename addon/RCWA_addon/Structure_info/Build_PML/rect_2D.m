% rect_2D

function y=rect_2D(k,l,ep,Tx,Ty,x1,x2,y1,y2)

dx=abs(x1-x2);
dy=abs(y1-y2);

y=ep*( (dx/Tx)*sinc(dx*k/Tx)*exp(-j*pi*k/Tx*(x1+x2)) )*( (dy/Ty)*sinc(dy*l/Ty)*exp(-j*pi*l/Ty*(y1+y2)) );