function [theta, fi, e] = ident_lambda_FIR(u,y, lam)
N = length(u);
r = 2;
fi = [u(1:N)'; 0, u(1:N-1)'];
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));

for t = 3 : N 
    R = zeros(r,r); 
    rk = zeros(r,1);
    
    for i = 1:t   
        R = R + lam^abs(t-i) * fi(:,i) * fi(:,i)';
        rk = rk + lam^abs(t-i) * y(i) * fi(:,i);
            
    end
    theta(:, t) = inv(R) * rk;
    
    y_est(t) = fi(:,t)' * theta(:,t);
    
    a = fi(:, t)' * inv(R) * fi(:, t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
end

disp(sprintf('n = %d : %1.4f', lam,  sum((y - y_est) .^2)))