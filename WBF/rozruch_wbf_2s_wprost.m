    
wbf_fixed;
%
% sv=0.2;
% [fi, y, th] = generuj('A', sv, 2);

N = length(y);

lam = 0.99;

k = 2; % liczba funkcji
n = 2; % liczba parametrów

In = diag(ones(n,1));
Ik = diag(ones(k,1));

B = [1 0; nad(1,1) 1];
f = zeros(k, N);
f2 = zeros(k, N);
f2(:,1) = [1,1]';

gam = zeros(k*n, N);
L = zeros(size(gam));
Q = zeros(k*n,k*n, N);
e=zeros(size(y));
Q(:,:,1) = diag(ones(k*n, 1));

C = kron(Ik, B);
C1 = inv(C);
CT = C1';
f0 = zeros(k,1);
f0(1) = 1;

beta = zeros(k*n, N);
L = zeros(size(beta));
e = zeros(size(y));
dzeta = zeros(size(L));

FI = zeros(size(beta));

f1 = [1,1]';

G = zeros(k*n, k*n, N);
h = zeros(k*n,N);

warning off;
for t = 2:N
    f = [sqrt(1-lam), (1-lam)*sqrt((1-lam)/lam)*(t-1) - sqrt(lam*(1-lam))]';
    
    FI(:,t) = kron(fi(:,t), f);
    
    G(:,:,t) = lam*C*G(:,:,t-1) + FI(:,t)*FI(:,t)';
    h(:,t) = lam*C*h(:,t) + y(t)*FI(:,t);
    
    beta(:,t) = G(:,:,t)\h(:,t);
    
end
warning on

Z = kron(Ik, f0)';
th2 = Z*beta;

%rysuj(th,  th2)

