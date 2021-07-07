close all
N = 5000;
T = 1:N;

[b1, b2] = parametry(N, 'A');

th = [b1;b2];
beta = 1;
r = 2;

wyniki = zeros(1, 5);

id = 0;
% u = randn(N, 1);
u = idinput(N, 'prbs');
y = zeros(N, 1);

y_est = zeros(size(y));
fi = zeros(2,N);

for t=3:N
    %y(t)= b1(t)*u(t)+b2(t)*u(t-1) + L(0,0,0.05);
    y(t) = b2(t) * u(t-1) + b1(t) * u(t) + 0.05*randn(1);
    fi(:,t) = [u(t);u(t-1)];
end

l = 50;

[th1] = kalman_2s_v2(fi, y, (sigmaw(50, 0.05)), 0.05);
[th2, e2] = EWLS(fi,y, 50);
[th3, e3] = SWLS(fi,y, 50);

p = plot(th(1,:), 'k');
set(p, 'LineWidth', 2);
hold on
plot(th1(1,:), 'r')
plot(th2(1,:), 'g')
plot(th3(1,:), 'b')
legend('\theta_1', 'Kalman', 'EWLS', 'SWLS');
set(gcf, 'color', 'white');

figure;
p = plot(th(2,:), 'k');
set(p, 'LineWidth', 2);
hold on
plot(th1(2,:), 'r')
plot(th2(2,:), 'g')
plot(th3(2,:), 'b')
legend('\theta_2', 'Kalman', 'EWLS', 'SWLS');
set(gcf, 'color', 'white');
