close all
clear all
N = 5000;
T = 1:N;

par = 1;

[b1, b2] = parametry(N, 'B');
th = [b1;b2];

r = 2;

u = idinput(N, 'prbs'); % randn(N, 1);
u=randn(N,1);
y = zeros(N, 1);
y_est = zeros(size(y));


for t=r:N
    % y(t)= b1(t)*u(t-1)+b2(t)*u(t-2);   
    y(t) = b2(t) * u(t-1) + b1(t) * u(t);
end
ref= std(y);
y = y + ref*0.1*randn(size(y));

e = [];
e2 = [];
e3=[];
e4=[];

L = [];

for linf = 3:40
    L = [L, linf];
    [th1, fi1, ye1] = ident_lambdaf_FIR_dwustr(u, y, lambda(linf));
    e = [e, blad(th, th1)];
    [th1, fi1, ye1] = ident_lambda_FIR_rek(u, y, lambda(linf));
    e2 = [e2, blad(th, th1)];
    [th1, fi1, ye1] = ident_rectw_FIR(u, y, linf);
    e3 = [e3, blad(th, th1)];
    [th1, fi1, ye1] = ident_rectw_FIR_lewostr(u, y, linf);
    e4 = [e4, blad(th, th1)];
end



if par == 1
    x = 'FIR_B';
else
    x='FIR_A';
end

save 'krzywe_B' e e2 e3 e4

f = figure('position', [50, 70, 800, 600], 'color', 'white');
set(gca, 'FontSize', 16);
p = plot(L,e, 'k+');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)
hold on
p = plot(L, e2, 'kx');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)
p = plot(L, e3, 'ko');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)
p = plot(L, e4, 'kd');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)

set(gca, 'XLim', [min(L)-1, max(L)+1])
t = text(0.05, 0.92, sprintf('%s', x), 'Units', 'Normalized', 'FontSize', 30);
set(t, 'fontweight', 'bold');
fr = getframe(gcf);
imwrite(fr.cdata, sprintf('krzywe/%s.png', x));
set(gcf, 'paperpositionMode', 'auto')
saveas(gcf, sprintf('krzywe/%s.eps', x), 'epsc');