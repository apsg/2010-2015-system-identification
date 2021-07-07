function thc = medley(th, e, beta)
M = 31;
[K, N] = size(e);
h = ones(1, M);

for i=1:K
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
mk1 = mk;

th1 = th(:,:,1);
th2 = th(:,:,2);
th3 = th(:,:,3);


a1_c3 = th1(1,:).*mk(1,:) + th2(1,:).*mk(2,:) + th3(1,:).*mk(3,:);
b1_c3 = th1(2,:).*mk(1,:) + th2(2,:).*mk(2,:) + th3(2,:).*mk(3,:);


thc = [a1_c3; b1_c3];