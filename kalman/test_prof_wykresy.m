
% -----------------------------------------------
close all

    [fi, y, th] = generuj('B', sv);
[x, idmin] = min(wyniki);
[x, idmax] = max(wyniki);
b = sort(wyniki);
idb = find(b>=median(b),1);
idmed = find(wyniki == b(idb));

thmin = trajektorie(:,:,idmin);
thmax = trajektorie(:,:,idmax);
thmed = trajektorie(:,:, idmed);

thm = thmin;

figure;
p1= plot(th(1, :), 'k--'), hold on
p2 = plot(thm(1,:), 'k')
set(p1, 'LineWidth', 1);
set(p2, 'LineWidth', 1);
set(gca, 'FontSize', 28);

figure;
p1= plot(th(1, :), 'k--'), hold on
p2 = plot(thmed(1,:), 'k')
set(p1, 'LineWidth', 1);
set(p2, 'LineWidth', 1);
set(gca, 'FontSize', 28);

figure;
p1= plot(th(1, :), 'k--'), hold on
p2 = plot(thmax(1,:), 'k')
set(p1, 'LineWidth', 1);
set(p2, 'LineWidth', 1);
set(gca, 'FontSize', 28);

