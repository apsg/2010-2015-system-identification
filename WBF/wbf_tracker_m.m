function [th, em] = wbf_tracker_m(fi,y,lam, k)

N = length(y);


f1 = [1;1;1];
n = 2; % liczba parametrów

In = diag(ones(n,1));
Ik = diag(ones(k,1));

B = [1 0 0; 1 1 0; 1 1 1];

Q = zeros(k*n,k*n, N);
e=zeros(size(y));
Q(:,:,1) = diag(ones(k*n, 1));


C = kron(In, B(1:k, 1:k));
C1 = inv(C);
CT = C1';
f0 = zeros(k,1);
f0(1) = 1;

beta = zeros(k*n, N);

L = zeros(size(beta));
em = zeros(size(y));
dzeta = zeros(size(L));

h = zeros(size(dzeta));


R = zeros(size(Q));
R(:,:,1) = diag(10*ones(n*k,1));
warning off
for t=2:N
    dzeta(:,t) = kron(fi(:,t), f0);
    em(t) = y(t) - dzeta(:,t)'*beta(:, t-1);
    
    FI = kron(fi(:,t), f1(1:k));
    
    h(:,t) = lam*C*h(:,t-1) + y(t)*FI;
    
    % wersja wprost, z odwracaniem macierzy (6.58 s.202 + 6.66, str. 204 )
    
    R(:,:,t) = lam*C*R(:,:,t-1)*C' + FI*FI';
    beta(:,t) = R(:,:,t)\h(:,t);

    
    
end
warning on


Z = kron(In, f0)';
th = Z*beta;

