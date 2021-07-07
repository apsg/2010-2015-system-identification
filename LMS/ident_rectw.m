function theta = ident_rectw(fi,y, n)
N = length(y);
r = 2;
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));
for t = n + 1 : N - n
    R = zeros(r,r); 
    S = zeros(r,1);
    for i = t - n:t+n
        R = R + fi(:,i) * fi(:,i)';
        S = S + y(i) * fi(:,i);
    end
    theta(:, i) = inv(R) * S;
    y_est(i) = fi(:,i)' * theta(:,i);
    
    a = fi(:, t)' * inv(R) * fi(:, t);
    e(t) = (y(t) - y_est(t)) / (1 - a);
end
