function [theta, fi, e,e2] = ident_lambdaf_AR_rek(y, lam)
N = length(y);
r = 2;
fi = [0,y(1:N-1)'; 0,0,y(1:N-2)'];
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));
e2 = zeros(size(y));

R = zeros(r,r);
rk = zeros(r,1);
t = 20;
for i = 1:t   
    R = R + lam^abs(t-i) * fi(:,i) * fi(:,i)';
    rk = rk + lam^abs(t-i) * y(i) * fi(:,i);
end

for t = 20 : N 
    R = lam * R + fi(:, t)*fi(:,t)';
    rk = lam * rk + y(t) * fi(:,t);
    
    theta(:, t) = inv(R) * rk;
    
    y_est(t) = fi(:,t)' * theta(:,t);
    
    a = fi(:, t)' * inv(R) * fi(:, t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
    e2(t) = (y(t) - y_est(t))*(1+a);
end
