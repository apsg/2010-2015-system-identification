function [theta, fi, e, e2] = simplified_EWLS(fi,y, lam)
N = length(y);
r = size(fi,1);
I = diag(ones(r,1));
n = lam;
lam = lambda(n);

thetaf = zeros(r, N);
thetaf(:,1) = [0;0];

Pkf = zeros(r,r,N);
Pkf(:,:,1) = diag([100,100]);

ek = zeros(size(y));

hkf = zeros(size(fi));

gammaf = zeros(size(fi));

etaf = zeros(N,1);
etaf(1) = 0;

% Forward - time run

for t = 2:N
   ek(t) = y(t) - fi(:,t)'*thetaf(:, t-1);
   hkf(:,t) = (Pkf(:,:,t-1) * fi(:,t)) / (lam + fi(:,t)' * Pkf(:,:,t-1) * fi(:,t));

   thetaf(:,t) = thetaf(:,t-1) + hkf(:,t) * ek(t);
   
   Pkf(:,:,t) = (1/lam) * (I - hkf(:,t)*fi(:,t)') * Pkf(:,:, t-1);
   
   etaf(t) = lam*etaf(t-1) + 1;
   gammaf(:,t) = etaf(t) * thetaf(:,t);
   
end

% Backward - time run

theta = zeros(size(thetaf));
theta(:, N) = thetaf(:,N);

eta = zeros(size(etaf));
eta(N) = etaf(N);

gamma(:,N) = gammaf(:,N);

gamma = zeros(size(gamma));

e = zeros(size(y));
e2 = zeros(size(y));
y_est = zeros(size(y));

for t = N-1:-1:1
    eta(t) = lam*eta(t+1) + (1-lam^2)*etaf(t);
    gamma(:,t) = lam*gamma(:, t+1) + (1-lam^2) * gammaf(:,t);
    theta(:,t) = gamma(:,t) / eta(t);
    
    qk = (etaf(t)/eta(t)) * fi(:,t)'*Pkf(:,:,t)*fi(:,t);
    y_est(t) = fi(:,t)' * theta(:,t);
    e(t) = (y(t) - y_est(t)) / ( 1 - qk);
    
    e2(t) = (y(t) - y_est(t)) * (1+qk);
end
    
