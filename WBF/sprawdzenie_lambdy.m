lam = lambda1(10);

% ---- pierwsza pochodna ----
lewa =  lam*(1+lam)*(lam^2 + 10*lam + 1)/(1-lam)^5


prawa = 0;
for i=0:10000
    prawa = prawa + i^4 * lam^abs(i);
end
prawa = prawa