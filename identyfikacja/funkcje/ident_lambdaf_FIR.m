function [theta, fi, e] = ident_lambdaf_FIR(u,y, lam)
N = length(u);
r = 2;
fi = [u(1:N)'; 0, u(1:N-1)'];
theta = zeros(size(fi));
y_est = zeros(size(y));
e = zeros(size(y));
thetao = zeros(size(theta));

for t = N:-1:1
    Rf = zeros(r,r); 
    rkf = zeros(r,1);
    
    Rfo = zeros(r,r); 
    rkfo = zeros(r,1);
    
    for i = 1:N   
        Rf = Rf + lam^abs(t-i) * fi(:,i) * fi(:,i)';
        rkf = rkf + lam^abs(t-i) * y(i) * fi(:,i);
        
        if(i~=t)
            Rfo = Rfo + lam^abs(t-i) * fi(:,i) * fi(:,i)';
            rkfo = rkfo + lam^abs(t-i) * y(i) * fi(:,i);
        end
    end
    theta(:, t) = inv(Rf) * rkf;
    
    thetao(:,t) = inv(Rfo) * rkfo;
    
    y_est(t) = fi(:,t)' * theta(:,t);
    e(t) = y(t) - fi(:,t)' * thetao(:,t);
    
end

disp(sprintf('n = %d : %1.4f', lam,  sum((y - y_est) .^2)))