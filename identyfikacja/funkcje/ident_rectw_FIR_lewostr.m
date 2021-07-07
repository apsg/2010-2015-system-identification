function [theta, fi, e] = ident_rectw_FIR_lewostr(u,y, n)
N = length(u);
r = 2;
fi = [u(1:N)'; 0, u(1:N-1)'];
theta = zeros(size(fi));
thetao = zeros(size(fi));
y_est = zeros(size(y));
y_esto = zeros(size(y));
e = zeros(size(y));
for t = 2*n + 2 : N
    R = zeros(r,r); 
    S = zeros(r,1);
    
    for i = t - 2*n - 1:t
        R = R + fi(:,i) * fi(:,i)';
        S = S + y(i) * fi(:,i);
    end
    theta(:, t) = inv(R) * S;    
    y_est(t) = fi(:,t)' * theta(:,t);
    
    a = fi(:, t)' * inv(R) * fi(:, t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
end