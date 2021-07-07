function l = lambda1(n)
if(n>30)
    start = 0.98;
elseif(n>40)
    start = 0.9;
else
    start = 0.85;
end

l = fzero(@(lam) ((1+lam)/ (1-lam)) - n, start);