function [theta, fi, e] = ident_lambda(u,y, lam)
N = length(u);
r = 2;
fi = [y(2:N)', 0; u(1:N)'];
theta = zeros(size(fi));
y_est = zeros(size(y));

R = zeros(r,r); 
rk = zeros(r,1);
for t = 3 : N 
    
    R = lam * R + fi(:,i) * fi(:,i)';
    rk = lam*rk + y(i) * fi(:,i);
    
    theta(:, t) = inv(R) * rk;
    y_est(t) = fi(:,t)' * theta(:,t);
    
    a = fi(:, t)' * inv(R) * fi(:, t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
end

disp(sprintf('n = %d : %1.4f', lam,  sum((y - y_est) .^2)))