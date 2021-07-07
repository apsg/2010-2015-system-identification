function [theta, fi, e] = ident_lambdaf_FIR_rek(u,y, lam)
N = length(u);
r = 2;
fi = [u(1:N)'; 0, u(1:N-1)'];
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));
thetao = zeros(size(theta));

for t = N:-1:1
    if(t == N)    
        Rf = zeros(r,r); 
        rkf = zeros(r,1);
        rk = zeros(r,1);
        R = zeros(r,r);
        
        for i = 1:N   
            Rf = Rf + lam^abs(t-i) * fi(:,i) * fi(:,i)';
            rkf = rkf + lam^abs(t-i) * y(i) * fi(:,i);
        end
        R = Rf;
        rk = rkf;
    else 
        R = (R - fi(:,t+1) * fi(:, t+1)') / lam;
        Rf = lam * Rf +  R/(lam^2);
        
        rk = (rk - y(t+1) * fi(:, t+1)) / lam;
        rkf = lam * rkf + rk / (lam^2);
    end
    
    theta(:, t) = inv(Rf) * rkf;
    
    %  thetao(:,t) = inv(Rfo) * rkfo;
    
    y_est(t) = fi(:,t)' * theta(:,t);
    % e(t) = y(t) - fi(:,t)' * thetao(:,t);
    e(t) = y(t) - y_est(t);
end

disp(sprintf('n = %d : %1.4f', lam,  sum((y - y_est) .^2)))