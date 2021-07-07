function AR_1p()
close all
clear all
N = 2000;
T = 1:N;
blocks = makesig('Doppler', N+1000)';
blocks = blocks(501 : 500+N);

a1 =  1 + 0.5*  blocks / max(blocks(:)) ;

r = 2;

u = randn(N, 1);

y = zeros(N, 1);
y(1) = 1;
y_est = zeros(size(y));

for t=2:N
    y(t) = a1(t) * y(t-1) + 0.1*randn(1);
end

e = zeros(3, N);

[th1, fi1, ye1] = ident_rectw_ar_1p( y, 10);
[th2, fi2, ye2] = ident_rectw_ar_1p( y, 20);
[th3, fi3, ye3] = ident_rectw_ar_1p(y, 40);


m = 10; M = 2*m+1;  % okno decyzyjne
K = 3;              % liczba filtrów

h = ones(1, M);

e(1, :) = ye1';
e(2, :) = ye2';
e(3, :) = ye3';

for i=1:3
    esum(i,:) = filter2(h, abs(e(i,:)).^2);
end
esum(esum ==0) = eps;
psi = (-M/2) * log(esum);

psimax = max(psi, [],1);
chi = zeros(size(psi));
for i=1:K
    chi(i,:) = psi(i,:) - psimax;
end
chi = exp(chi);
chisums = sum(chi,1);
mk = zeros(size(e));
for i=1:K
    mk(i,:) = chi(i,:)./ chisums;
end

a1_c3 = th1(:)'.*mk(1,:) + th2(:)'.*mk(2,:) + th3(:)'.*mk(3,:);

%fi = [y(2:N)', 0; u(1:N)'];
fi = [0, y(1:N-1)'];

yc3 = zeros(size(y));
for i=1:N
    th = [a1_c3(i);]
    yc3(i) = fi(i)' * th;
end
disp(sprintf('medley : %2.3f',  sum((y(m:N-m) - yc3(m:N-m)) .^2)))


figure;
plot(T, a1, 'k'), hold on
plot(T, th1, 'r--');
plot(T, th2, 'g:');
plot(T, th3, 'b-.');
title('a1'), legend('a1', 'estymator 1', 'estymator 2', 'estymator 3')

figure;
plot(T, a1, 'k'), hold on
plot(T, a1_c3, 'r--');
title('a1'), legend('b1', 'b1 medley')

figure;
subplot(2,1,1), plot(T,y)
hold on
subplot(2,1,1),
plot(T, yc3, 'k')
legend('Y', 'oszacowanie Y')

subplot(2,1,2), plot( T, (y - yc3).^2), legend('Kwadrat bledu')

figure, title('Uzycie poszczegolnych estymatorow')
subplot(4,1,1), plot(a1) 
subplot(4,1,2), plot(mk(1,:)) 
set(gca, 'YLim', [-0.05, 1.05])
subplot(4,1,3), plot(mk(2,:)) 
set(gca, 'YLim', [-0.05, 1.05])
subplot(4,1,4), plot(mk(3,:)) 
set(gca, 'YLim', [-0.05, 1.05])

function [theta, fi, e] = ident_rectw_ar_1p(y, n)
N = length(y);
r = 1;
fi = [0; y(1:N-1)];
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));

for t = n + 1 : N - n
    R = zeros(r,r); 
    S = zeros(r,1);
    
    for i = t - n:t
        R = R + fi(i) * fi(i)';
        S = S + y(i) * fi(i);
    end
    theta(t) = inv(R) * S;
    
    y_est(t) = fi(t)' * theta(t);
    
    a = fi(t)' * inv(R) * fi( t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
    
end
m = 35;
disp(sprintf('n = %d : %2.3f', n,  sum((y(m:N-m) - y_est(m:N-m)) .^2)))
%disp(sprintf('n = %d : %2.3f', n,  sum((y(m:N-m) - y_esto(m:N-m)) .^2)))
