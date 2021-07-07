function [theta, eo, ep] = SWLS(fi, y, n)
N = length(y);
r = size(fi,1);
theta = zeros(size(fi));
y_est = zeros(size(y));
eo = zeros(size(y));
ep = zeros(size(y));
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
    eo(t) = (y(t) - y_est(t)) / (1 - a);
    if nargout>2
        ep(t) = (y(t) - y_est(t)) *(1 + a);
    end
end