function [theta, eo, ep] = EWLS(fi, y, lam)
if(lam>1)
    lam = lambda(lam);
end

N = length(y);
r = 2;
theta = zeros(size(fi));
y_est = zeros(size(y));
eo = zeros(size(y));
ep = zeros(size(y));
thetao = zeros(size(theta));

% rekurencyjnie, estymacja w przód.
Rkf = zeros(r,r, N); 
rkf = zeros(r,N);
Rkf(:,:,1) = fi(:,1)*fi(:, 1)';
rkf(:,1) =  y(1) * fi(:,1);

for t = 2:N 
    Rkf(:,:,t) = lam * Rkf(:,:,t-1) + fi(:, t) * fi(:,t)';
    rkf(:,t) = lam*rkf(:,t-1) + y(t) * fi(:, t);
end

% Filtracja w tył
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
    eo(t) = (y(t) - y_est(t)) / (1 - a);
    ep(t) = (y(t) - y_est(t))*(1+a);
end