function [theta, eo] = EWLS_1s(fi, y, lam)
if(lam>1)
    lam = lambda2(lam);
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
    
    theta(:, t) = inv(Rkf(:,:,t)) * rkf(:,t);
    
    y_est(t) = fi(:,t)' * theta(:,t);
    a = fi(:, t)' * inv(Rkf(:,:,t)) * fi(:, t);
    eo(t) = (y(t) - y_est(t)) / (1 - a);
end
