close all
clear all
N = 5000;
T = 1:N;

[a1, a2] = parametry(N, 1);

r = 2;
rng = abs(max(a2) - min(a2));
u = 0.1*rng*randn(N, 1);

y = zeros(N, 1);
y_est = zeros(size(y));

y(1) = 0;
y(2) = 0;
for t=3:N
    y(t) = a1(t) * y(t-1) + a2(t) * y(t-2) + 0.1*randn(1);
end

e = zeros(3, N);

[th1, fi1, ye1] = ident_rectw_ar(u, y, 5);
[th2, fi2, ye2] = ident_rectw_ar(u, y, 15);
[th3, fi3, ye3] = ident_rectw_ar(u, y, 45);


m = 15; M = 2*m+1;  % okno decyzyjne
K = 3;              % liczba filtr�w

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

a1_c3 = th1(1,:).*mk(1,:) + th2(1,:).*mk(2,:) + th3(1,:).*mk(3,:);
b1_c3 = th1(2,:).*mk(1,:) + th2(2,:).*mk(2,:) + th3(2,:).*mk(3,:);

%fi = [y(2:N)', 0; u(1:N)'];
fi = [0, y(1:N-1)'; 0,0, y(1:N-2)'];

yc3 = zeros(size(y));
for i=1:N
    th = [a1_c3(i);
        b1_c3(i)];
    yc3(i) = fi(:,i)' * th;
end
disp(sprintf('medley : %2.3f',  sum((y(m:N-m) - yc3(m:N-m)) .^2)))
% 

figure;
subplot(2,1,1)
plot(T, a1, 'k'), hold on
plot(T, th1(1,:), 'r--');
plot(T, th2(1,:), 'g:');
plot(T, th3(1,:), 'b-.');
set(gca, 'YLim', [-.5,1])
title('a1'), legend('a1', 'estymator 1', 'estymator 2', 'estymator 3')

subplot(2,1,2)
plot(T, a2, 'k'), hold on
plot(T, th1(2,:), 'r:')
plot(T, th2(2,:), 'g--')
plot(T, th3(2,:), 'b-.')
title('a1'), legend('a2', 'estymator 1', 'estymator 2', 'estymator 3')

figure;
subplot(2,1,1)
plot(T, a1, 'k'), hold on
plot(T, a1_c3, 'r--');
set(gca, 'YLim', [-.5,1])
title('a1')
legend('b1', 'b1 medley')

subplot(2,1,2)
plot(T, a2, 'k'), hold on
plot(T, b1_c3, 'r:')
title('b1') 
legend('b2', 'b2 medley')

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
