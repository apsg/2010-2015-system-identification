function [th, eo] = wbf_smoother(fi, y, lam, k)
N = length(y);


n = 2; % liczba parametrów

In = diag(ones(n,1));
Ik = diag(ones(k,1));
f1 = [1;1;1];
B = [1 0 0; 1 1 0; 1 1 1];


Q = zeros(k*n,k*n, N);
e=zeros(size(y));
Q(:,:,1) = diag(ones(k*n, 1));


C = kron(In, B(1:k,1:k));
C1 = inv(C);
CT = C1';
f0 = zeros(k,1);
f0(1) = 1;

beta = zeros(k*n, N);

L = zeros(size(beta));
e = zeros(size(y));
dzeta = zeros(size(L));

h = zeros(size(dzeta));

R = zeros(size(Q));
R(:,:,1) = diag(10*ones(n*k,1));
warning off
for t=2:N
    dzeta(:,t) = kron(fi(:,t), f0);
    e(t) = y(t) - dzeta(:,t)'*beta(:, t-1);
    
    FI = kron(fi(:,t), f1(1:k));
    
    h(:,t) = lam*C*h(:,t-1) + y(t)*FI;
    
    % wersja wprost, z odwracaniem macierzy (6.58 s.202 + 6.66, str. 204 )
    
    R(:,:,t) = lam*C*R(:,:,t-1)*C' + FI*FI';
    beta(:,t) = R(:,:,t)\h(:,t);
    
end
warning on
Rp = zeros(size(R));
Rp(:,:, N) = R(:,:,N);
hp = zeros(size(h));
hp(:,end) = h(:,end);
betap = zeros(size(beta));

eo = zeros(size(e));
q = zeros(size(y));

% moje wyprowadzenie
for t = N-1:-1:1
    Rp(:,:,t) = lam*C1*Rp(:,:,t+1)*CT + (1-lam^2) * R(:,:,t);
    hp(:,t) = lam*C1*hp(:,t+1) + (1-lam^2) * h(:,t);
    betap(:,t) = Rp(:,:,t)\hp(:,t);
    
    FI = kron(fi(:,t), f1(1:k));
    e(t) = y(t) - FI' * betap(:,t);
    
    
    q(t) = FI' / Rp(:,:,t) * FI;
    eo(t) = e(t) / (1-q(t));
end

Z = kron(In, f0)';
th = Z * betap;
