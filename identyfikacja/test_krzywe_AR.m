N = 5000;
[b1, b2] = parametry(N, 'A');
std = 0.1;
id = 1;
e = [];
e1 = [];
e2 = [];
e3 = [];

l = [];
        th = [b1;b2];
        
        y = zeros(N, 1);
        y_est = zeros(size(y));

        fi = zeros(2, N);
        for t=3:N
            y(t) = b2(t) * y(t-2) + b1(t) * y(t-1) + std* randn(1);
            fi(:,t) = [y(t-1);y(t-2)];
        end
for lam = 50:100
        l = [l, lam];
        % fi = [0, y(1:N-1)'; 0,0, y(1:N-2)'];
        th1 = SWLS(fi, y, lam);
        e1 = [e1,  blad(th, th1)] ;
        
        th1 = ident_rectw_ar(y, lam);
        e2 = [e2, blad(th, th1)];

        [th1, yo1, yp1] = EWLS(fi, y, lam);
        e = [e,  blad(th, th1)];
        
        
        [th1, yo1, yp1] = EWLS_1s(fi, y, lam);
        e3 = [e3,  blad(th, th1)];
        
        
        
end

hold on 




x= 'AR_A';

f = figure('position', [50, 70, 800, 600], 'color', 'white');
set(gca, 'FontSize', 16);
p = plot(l, e1, 'ko');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)
hold on
p = plot(l, e2, 'kd');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)
p = plot(l,e, 'k+');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)
p = plot(l, e3, 'kx');
set(p, 'LineWidth', 2)
set(p, 'MarkerSize', 10)

set(gca, 'XLim', [min(l)-1, max(l)+1])
t = text(0.05, 0.92, sprintf('%s', x), 'Units', 'Normalized', 'FontSize', 30);
set(t, 'fontweight', 'bold');
fr = getframe(gcf);
imwrite(fr.cdata, sprintf('krzywe/%s.png', x));
set(gcf, 'paperpositionMode', 'auto')
saveas(gcf, sprintf('krzywe/%s.eps', x), 'epsc');
