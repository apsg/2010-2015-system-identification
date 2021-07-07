function [theta, fi, e] = ident_rectw_FIR(u,y, n)
N = length(u);
r = 2;
fi = [u(1:N)'; 0, u(1:N-1)'];
theta = zeros(size(fi));
thetao = zeros(size(fi));
y_est = zeros(size(y));
y_esto = zeros(size(y));
e = zeros(size(y));
for t = n + 1 : N - n
    R = zeros(r,r); 
    S = zeros(r,1);
    
    for i = t - n:t+n
        R = R + fi(:,i) * fi(:,i)';
        S = S + y(i) * fi(:,i);
    end
    theta(:, t) = inv(R) * S;    
    y_est(t) = fi(:,t)' * theta(:,t);
    
    a = fi(:, t)' * inv(R) * fi(:, t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
end
m = 35;
disp(sprintf('n = %d : %2.3f', n,  sum((y(m:N-m) - y_est(m:N-m)) .^2)))

%disp(sprintf('n = %d : %2.3f', n,  sum((y(m:N-m) - y_esto(m:N-m)) .^2)))