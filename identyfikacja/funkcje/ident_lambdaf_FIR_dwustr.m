function [theta, fi, e] = ident_lambdaf_FIR_dwustr(u,y, lam)
N = length(u);
r = 2;
fi = [u(1:N)'; 0, u(1:N-1)'];
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));
thetao = zeros(size(theta));

% rekurencyjnie, estymacja w prz�d.
Rkf = zeros(r,r, N); 
rkf = zeros(r,N);
Rkf(:,:,1) = fi(:,1)*fi(:, 1)';
rkf(:,1) =  y(1) * fi(:,1);

for t = 2:N 
    Rkf(:,:,t) = lam * Rkf(:,:,t-1) + fi(:, t) * fi(:,t)';
    rkf(:,t) = lam*rkf(:,t-1) + y(t) * fi(:, t);
end

% Filtracja w ty�
Rk = zeros(r,r,N);
rk = zeros(r, N);

Rk(:,:,N ) = Rkf(:,:,N);
rk(:,N) = rkf(:,N);

for t = N-1: -1 : 1
    Rk(:,:,t) = lam * Rk(:,:,t+1) + (1 - lam^2) * Rkf(:,:,t);
    rk(:,t) = lam * rk(:,t+1) + (1-lam^2 ) * rkf(:,t);
    
    theta(:, t) = inv(Rk(:,:,t)) * rk(:, t);
    y_est(t) = fi(:,t)' * theta(:,t);
    
    a = fi(:, t)' * inv(Rk(:,:,t)) * fi(:, t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
end
