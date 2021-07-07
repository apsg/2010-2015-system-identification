function trojkat(a1, a2, id)

disp(sprintf('L2(a1): %2.2f', l2(a1)));
disp(sprintf('L2(a2): %2.2f', l2(a2)));

if(ischar(id))
    if(strcmp(id, 'A'))
        id = 2;
    else
        id = 1;
    end
end
close all
xx = [-1, 0, 1, -1];
yy = [-1, 1, -1, -1];
p = plot(xx, yy, 'r');
set(p, 'LineWidth', 2);
hold on
if id == 2
    x = 'A';
    plot(a1, a2, '.');
else
    x='B';
    plot(a1, a2);
end

f = figure('position', [50, 70, 800, 600], 'color', 'white');

set(gca,'FontSize',25,'FontWeight','bold','FontName','Arial')
if id==2
    p = stairs(a1, 'k');
else
    p = plot(a1, 'k');
end
set(p, 'LineWidth', 2);
set(gca, 'YLim', [-1,1]);

t = text(0.92, 0.92, x, 'FontSize', 30, 'Units', 'Normalized');
t = text(0.05, 0.9, '\theta_1(t)', 'FontSize', 30, 'Units', 'Normalized');

fr = getframe(gcf);
imwrite(fr.cdata, sprintf('parametry/%s1.png', x));
set(gcf, 'paperpositionMode', 'auto');
saveas(gcf, sprintf('parametry/%s1.eps', x), 'epsc');

f = figure('position', [50, 70, 800, 600], 'color', 'white');
set(gca,'FontSize',25,'FontWeight','bold','FontName','Arial')
if id == 2
    p=stairs(a2, 'k');
else
    p = plot(a2, 'k');
end
set(p, 'LineWidth', 2);
set(gca, 'YLim', [-1,1]);
t = text(0.92, 0.92, x, 'FontSize', 30, 'Units', 'Normalized');
t = text(0.05, 0.9, '\theta_2(t)', 'FontSize', 30, 'Units', 'Normalized');

fr = getframe(gcf);
imwrite(fr.cdata, sprintf('parametry/%s2.png', x));
set(gcf, 'paperpositionMode', 'auto')
saveas(gcf, sprintf('parametry/%s2.eps', x), 'epsc');
