function [thm, e] = med(th, N)
h = ones(1, N);
n = ceil(N/2);
thm = ordfilt2(th, n, h);
e = th - thm;

h = ones(1,N);
h(ceil(N/2)) = 0;
y1 = ordfilt2(th, floor(N/2), h, 'symmetric');
y2 = ordfilt2(th, floor(N/2) + 1, h, 'symmetric');
y = (y1+y2)/2;

e = th - y;