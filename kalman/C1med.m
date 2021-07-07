function [th_C, mk] = C1med(th1, th2, th3, e1, e2, e3)
N = length(e1);
e = zeros(3, N);
m = 15; M = 2*m+1;  % okno decyzyjne
K = 3;              % liczba filtr�w

h = ones(1, M);

e(1, :) = e1(1,:);
e(2, :) = e2(1,:);
e(3, :) = e3(1,:);
esum = zeros(size(e));

beta = 2;

for i=1:3
    esum(i,:) = filter2(h, abs(e(i,:)).^beta);
end
esum(esum ==0) = eps;
psi = (-M/beta) * log(esum);

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
t1 = th1(1,:).*mk(1,:) + th2(1,:).*mk(2,:) + th3(1,:).*mk(3,:);


e(1, :) = e1(2,:);
e(2, :) = e2(2,:);
e(3, :) = e3(2,:);
esum = zeros(size(e));

beta = 2;

for i=1:3
    esum(i,:) = filter2(h, abs(e(i,:)).^beta);
end
esum(esum ==0) = eps;
psi = (-M/beta) * log(esum);

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

t2 = th1(2,:).*mk(1,:) + th2(2,:).*mk(2,:) + th3(2,:).*mk(3,:);
th_C = [t1; t2];