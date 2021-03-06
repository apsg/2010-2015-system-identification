function [theta, fi, e] = ident_rectw_ar(y, n)
N = length(y);
r = 2;
fi = [0,y(1:N-1)'; 0, 0, y(1:N-2)'];
theta = zeros(size(fi));
thetao = zeros(size(fi));
y_est = zeros(size(y));
y_esto = zeros(size(y));
e = zeros(size(y));
for t = 2*n + 2 : N
    R = zeros(r,r); 
    Ro = zeros(r,r);
    S = zeros(r,1);
    So = zeros(r,1);
    
    for i = t - 2*n-1:t
        R = R + fi(:,i) * fi(:,i)';
        S = S + y(i) * fi(:,i);
        if(i ~= t )
            Ro = Ro + fi(:,i) * fi(:,i)';
            So = So + y(i) * fi(:,i);
        end
    end
    theta(:, t) = inv(R) * S;
    thetao(:,t) = inv(Ro) * So;
    
    y_est(t) = fi(:,t)' * theta(:,t);
    y_esto(t) = fi(:,t)' * thetao(:,t);
    
    a = fi(:, t)' * inv(R) * fi(:, t);
    %e(t) = (y(t) - y_est(t)) / (1 - a);
    e(t) = y(t) - y_esto(t);
end