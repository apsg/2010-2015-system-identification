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
sv = 0.15;
for t=3:N
    %y(t)= b1(t)*u(t)+b2(t)*u(t-1) + L(0,0,0.05);
    y(t) = b2(t) * u(t-1) + b1(t) * u(t) + sv*randn(1);
    fi(:,t) = [u(t);u(t-1)];
end

F = diag([1 1]);

% --------------- W przód ----------------------------

sw = sigmaw(50, sv);


E = zeros(2,2,N);
Ep = zeros(size(E));
theta = zeros(size(fi));
thetap = zeros(size(fi));
K = zeros(size(theta));
e = zeros(size(y));

E(:,:,1) = diag([10,10]);
I = diag([1 1]);
k = sw/sv;

for t=2:N
    Ep(:,:,t) = E(:,:,t-1) + diag([k^2, k^2]);
    E(:,:,t) = Ep(:,:,t) - Ep(:,:,t)*fi(:,t)*fi(:,t)'*Ep(:,:,t) / (1 + fi(:,t)'*Ep(:,:,t)*fi(:,t));
    
    K(:,t) = Ep(:,:,t)*fi(:,t) / (1 + fi(:,t)'*Ep(:,:,t)*fi(:,t));
    thetap(:,t) = F*theta(:,t-1);
    e(t) = y(t) - fi(:,t)'*thetap(:,t);
    theta(:,t) = thetap(:,t) + K(:,t)*e(t);
end


% ---------------- Sposób 1. -------------------------

th1 = kalman_2s_v2(fi, y, sw, sv);

% ---------------- Sposób 2. (7.70) -------------------------

th2 = zeros(size(th));

for t = N-1:-1:1
    A(:,:,t) = E(:,:,t) * F' *inv(Ep(:,:,t+1));
    th2(:,t) = theta(:,t) + A(:,:,t) *(th2(:,t+1) - thetap(:, t+1));
end

% ---------------- Sposób 3.  7.73 -------------------------

th3 = zeros(size(th));
th4 = zeros(size(th));

L = zeros(size(th));
L2 = zeros(size(th));
Ka = zeros(size(fi));

for t=N-1:-1:1
    Ka(:,t) = E(:,:,t) * fi(:,t);
   L(:,t) = (I - Ka(:,t+1)*fi(:,t+1)')*( F'*L(:,t+1) - fi(:,t+1) * (y(t+1)-fi(:,t+1)'*thetap(:,t+1)) );
    L2(:,t) = (I - Ka(:,t+1)*fi(:,t+1)')'*(F'*L2(:,t+1) - fi(:,t+1)*(y(t+1)-fi(:,t+1)'*thetap(:,t+1)));
   th3(:,t) = theta(:,t) - E(:,:,t)*F'*L(:,t); 
   th4(:,t) = theta(:,t) - E(:,:,t)*F'*L2(:,t);
end

disp(blad(th3,th4))

% ----------------  Wykresy  -------------------------

p = plot(th(1,:), 'k');
set(gcf, 'color', 'white');
set(p, 'LineWidth', 2);
hold on
%plot(theta(1,:), 'g');
plot(th1(1,:), 'g');
plot(th2(1,:), 'r');
plot(th3(1,:), 'b');
l = legend('\theta_1', '\theta^{~}_1 (org)' , '\theta^{~}_1 (7.70)', '\theta^{~}_1 (7.73)');
set(l, 'FontSize', 16);
