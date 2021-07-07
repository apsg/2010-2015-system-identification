
sv=0.2;
[fi, y, th] = generuj('A', sv, 2);

N = length(y);

lam = 0.97;

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

the = zeros(size(th));

C = kron(Ik, B);
C1 = inv(C);
CT = C1';
f0 = zeros(k,1);
f0(1) = 1;

beta = zeros(k*n, N);
beta2 = zeros(k*n, N);
beta3 = zeros(k*n, N);

L = zeros(size(beta));
e = zeros(size(y));
dzeta = zeros(size(L));

h = zeros(size(dzeta));

R = zeros(size(Q));
R(:,:,1) = diag(10*ones(n*k,1));

for t=2:N
    dzeta(:,t) = kron(fi(:,t), f0);
    e(t) = y(t) - dzeta(:,t)'*beta(:, t-1);
    
    FI = kron(fi(:,t), [1;1]);
    
    h(:,t) = lam*C*h(:,t-1) + y(t)*FI;
    
    L(:,t) = Q(:,:,t-1)*dzeta(:,t) / ...
        (lam + dzeta(:, t)'*Q(:,:,t-1)*dzeta(:,t));
    
    Q(:,:,t) = (1/lam)*CT*(Q(:,:,t-1) -...
        Q(:,:,t-1)*dzeta(:,t)*dzeta(:,t)'*Q(:,:,t-1)/...
        (lam + dzeta(:, t)'*Q(:,:,t-1)*dzeta(:,t))...
        )/C;
    
    beta(:,t) = CT*(beta(:,t-1) + L(:,t)*e(t));
    
    beta2(:,t) = Q(:,:,t)*h(:,t);
    
    R(:,:,t) = lam*C*R(:,:,t-1)*C' + FI*FI';
    beta3(:,t) = R(:,:,t)\h(:,t);
    
end

disp(blad(beta2, beta3))

Rp = zeros(size(R));
Rp(:,:, N) = R(:,:,N);
hp = zeros(size(h));
Hp(:,N) = h(:,N);
betap = zeros(size(beta));

for t = N-1:-1:1
    Rp(:,:,t) = lam*C1*Rp(:,:,t+1)*CT + (1-lam^2) * R(:,:,t);
    hp(:,t) = lam*C1*hp(:,t+1) + (1-lam^2) * h(:,t);
    betap(:,t) = Rp(:,:,t)\hp(:,t);
end

Z = kron(Ik, f0)';
the = Z*beta;
th2 = Z*beta2;
th3 = Z*beta3;

thp = Z*betap;

rysuj(th, th3, thp)