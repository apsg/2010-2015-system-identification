
sv=0.2;
[fi, y, th] = generuj('A', sv, 2);

N = length(y);

lam = 0.97;

[ths, e, eo] = wbf_smoother(fi, y, lam);