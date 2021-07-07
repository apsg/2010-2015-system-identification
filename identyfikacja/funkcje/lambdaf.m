function lam = lambdaf(n)
lam = 0.9999;
N = linf(lam);
pow = 0;
while(abs(N - (n)) > 0.1 & pow < 10000)
    lam = lam - 0.0001;
    N = linf(lam);
    pow = pow+1;
end
l = lam;



function N = linf(lam)
N = (1+lam)/(1-lam);