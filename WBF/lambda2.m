function l = lambda(n)
% lam = 0.9999;
% N = linf(lam);
% pow = 0;
% delta = 0.1;
% while((N - (2*n + 1)) > 0.1 & pow < 10000)
%     lam = lam - 0.0002;
%     N = linf(lam);
%     pow = pow+1;
% end
% l = lam;

start = 0.8;
if n > 20
    start = 0.95;
end
if n> 70
    start = 0.999;
end

l = fzero(@(lam) (4/(5*(1-lam))) - n, start);
