function l = lambda3(n)
start = 0.99;
if n > 20
    start = 0.998;
end
if n> 70
    start = 0.999;
end

l = fzero(@(lam) (16/(33*(1-lam))) - n, start);
if(l>=1)
    l=0.9999;
end