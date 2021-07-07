close all
clear all
N = 2000;
T = 1:N;
blocks = makesig('Blocks', N+1000)';
blocks = blocks(251 : 250+N);

a1 =  0.3 *  blocks / max(blocks(:));
a1 = a1 -  min(a1(:)) + 0.1;

a2 = 0.5* blocks / max(blocks(:));
a2 = a2 - min(a2(:)) - 0.1;

b1 = a2;
% b1=-0.2*sign(sin(2*pi*(1:N)'/2000)); 
%b2= 1/N:1/N:1;         
% a1 = b2;
b2 = a1;

r = 2;


u=sin(0.50*(1:N)');                  % sygna³ wejœciowy
u=u+sin(0.101*(1:N)');
u=u+sin(0.203*(1:N)');
u=u+sin(0.405*(1:N)');
u=u+sin(0.807*(1:N)');

u = randn(N, 1);

y = zeros(N, 1);
y_est = zeros(size(y));


for t=r:N
    y(t) = b1(t) * u(t) + b2(t)*u(t-1) + 0.012 * randn(1);
end

fi = [u'; 0, u(1:N-1)'];
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));
    
n = 25;

for t = n + 1 : N - n
    R = zeros(r,r); 
    S = zeros(r,1);
    for i = t - n:t+n
        R = R + fi(:,i) * fi(:,i)';
        S = S + y(i) * fi(:,i);
    end
    theta(:, i) = inv(R) * S;
    y_est(i) = fi(:,i)' * theta(:,i);
end




figure;
subplot(2,1,1)
plot(T, b1, 'k'), hold on
plot(T, theta(1,:), 'r--');
title('b1')

subplot(2,1,2)
plot(T, b2, 'k'), hold on
plot(T, theta(2,:), 'r--');
title('b1')

