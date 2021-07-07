function thc = kalmed(th, e, beta)

if(nargin<3)
    beta = 2;
end

[I,J,K] = size(th);

% Size of the decision window
m = 15; M = 2*m+1;
h = ones(1, M);

esum = zeros(size(e));
for i=1:K
    esum(i,:) = filter2(h, abs(e(i,:)).^beta);
end

esum(esum ==0) = eps;
% log version - to avoid numerical errors
psi = (-M/beta) * log(esum);

psimax = max(psi, [],1);
chi = zeros(size(psi));
for i=1:K
    chi(i,:) = psi(i,:) - psimax;
end
chi = exp(chi);
chisums = sum(chi,1);
mk = zeros(size(e));
% computing the weights...
for i=1:K
    mk(i,:) = chi(i,:)./ chisums;
end

a1 = zeros(1,J);
a2 = zeros(1,J);

% Creating cooperative trajectories using basic trajectories (obtained by
% different filters) and weights computed above.
for i=1:K
    a1 = a1 + th(1,:,i).*mk(i,:);
    a2 = a2 + th(2,:,i).*mk(i,:);
end

thc = [a1;a2];

