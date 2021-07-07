function l = lambda2(n)
lam = 0.9999;
N = linf(lam);
pow = 0;
delta = 0.1;
while((N - (2*n + 1)) > 0.1 & pow < 10000)
    lam = lam - 0.0002;
    N = linf(lam);
    pow = pow+1;
end
l = lam;



function N = linf(lam)
N = (lam+1)/(1-lam);