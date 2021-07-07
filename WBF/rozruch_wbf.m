
sv=0.2;
[fi, y, th] = generuj('A', sv, 2);

N = length(y);

lam = 0.93;

k = 2; % liczba funkcji
n = 2; % liczba parametrów

In = diag(ones(n,1));

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
th2= zeros(size(th));

G = zeros(4,4,N);
h = zeros(4,N);

for t=2:N
    f(:,t) = [1,t]';
    f2(:,t) = B*f2(:,t-1);
    FI = kron(f(:,t), fi(:,t));
    e(t) = y(t) - FI'*gam(:,t-1);
    L(:,t) = Q(:,:,t-1)*FI / (lam + FI'*Q(:,:,t-1)*FI);
    
    gam(:,t) = gam(:,t-1) + L(:,t)*e(t);
    Q(:,:,t) = (1/lam)*(Q(:,:,t-1) - Q(:,:,t-1)*FI*FI'*Q(:,:,t-1)/(lam + FI'*Q(:,:,t-1)*FI));
    
    Z = kron(f(:,t)',In);
    the(:,t) = Z*gam(:,t);
    
    G(:,:,t) = lam*G(:,:,t-1) + FI*FI';
    h(:,t) = lam*h(:,t-1) + y(t)*FI;
    th2(:,t) = Z*(G(:,:,t)\h(:,t));
end

Gp = zeros(size(G));
Gp(:,:, N) = G(:,:,N);
hp = zeros(size(h));
hp(:,N) = h(:, N);

for t = N-1:-1:1
    Gp(:,:,t) = lam*Gp(:,:,t+1) + (1-lam^2)*G(:,:,t);
    hp(:,t) = lam*hp(:,t+1) + (1-lam^2)*h(:,t);
    
    Z = kron(f(:,t)',In);
    thp(:,t) = Z*(Gp(:,:,t)\hp(:,t));    
end

close all
rysuj(th, thp, the)