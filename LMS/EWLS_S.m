function [th, eo] = EWLS_S(fi, y, lam)

N = length(y);

warning off
Rf = zeros(2,2,N);
rf = zeros(size(fi));

etaf = zeros(N,1);
etaf(1) = 0;

for t=2:N
    Rf(:,:,t) = lam*Rf(:,:,t-1) + fi(:,t)*fi(:,t)';
    rf(:,t) = lam*rf(:,t-1) + y(t)*fi(:,t);
    
    
   etaf(t) = lam*etaf(t-1) + 1;
end

R = zeros(size(Rf));
r = zeros(size(rf));
th = zeros(size(fi));

R(:,:,N) = Rf(:,:,N);
r(:,N) = rf(:,N);
eo = zeros(size(y));

eta = zeros(size(etaf));
eta(N) = etaf(N);

for t=N-1:-1:1
    eta(t) = lam*eta(t+1) + (1-lam^2)*etaf(t);
    R(:,:,t) = lam*R(:,:,t+1) + (1-(lam^2))*Rf(:,:,t);
    r(:,t) = lam*r(:,t+1) + (1-(lam^2))*rf(:,t);
    th(:,t) = (R(:,:,t))\r(:,t);
    
    a = fi(:, t)' /(R(:,:,t)) * fi(:, t);
    eo(t) = (y(t) - fi(:,t)'*th(:,t)) / (1 - a);
end