[c1, c2] = parametry(5000, 'A');

f = figure;
set(f, 'Color', 'white')
p = plot(c1,'k');
set(p, 'LineWidth', 2);
set(gca, 'FontSize', 18)
set(gca, 'XLim', [0, 5000])
set(gca, 'YLim', [-1, 1])
t=text(200, 0.85, '\theta_1(t)')
set(t, 'FontSize', 20)


f = figure;
set(f, 'Color', 'white')
p = plot(c2,'k');
set(p, 'LineWidth', 2);
set(gca, 'FontSize', 18)
set(gca, 'XLim', [0, 5000])
set(gca, 'YLim', [-1, 1])
t=text(200, 0.85, '\theta_2(t)')
set(t, 'FontSize', 20)
