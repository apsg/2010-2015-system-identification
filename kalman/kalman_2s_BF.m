function [th, eo, ep] = kalman_2s_BF(fi, y, sw, sv)
warning off
N = length(y);
F = diag([1,1]);

E = zeros(2,2,N);
Ep = zeros(size(E));
theta = zeros(size(fi));
thetap = zeros(size(fi));
K = zeros(size(theta));
e = zeros(size(y));

E(:,:,1) = diag([2,2]);
I = diag([1 1]);
k = sw/sv;
s = zeros(size(e));

for t=2:N
    Ep(:,:,t) = E(:,:,t-1) + diag([k^2, k^2]);
    E(:,:,t) = Ep(:,:,t) - Ep(:,:,t)*fi(:,t)*fi(:,t)'*Ep(:,:,t) / (1 + fi(:,t)'*Ep(:,:,t)*fi(:,t));
    
    K(:,t) = Ep(:,:,t)*fi(:,t) / (1 + fi(:,t)'*Ep(:,:,t)*fi(:,t));
    thetap(:,t) = F*theta(:,t-1);
    e(t) = y(t) - fi(:,t)'*thetap(:,t);
    theta(:,t) = thetap(:,t) + K(:,t)*e(t);
    s(t) = fi(:,t)'*Ep(:,:,t)*fi(:,t);
end

thN = zeros(size(theta));
L = zeros(size(theta));
L2 = zeros(size(theta));
e = zeros(size(y));
eo = zeros(size(y));
ep = zeros(size(y));
K2 = zeros(size(fi));
B = zeros(2,2,N);
r = zeros(size(fi));
R = zeros(size(B));
EN = zeros(size(B));

for t = N:-1:2
    
    L(:,t-1) = (I - K(:,t)*fi(:,t)')*(F'*L(:,t) - fi(:,t)*(y(t) - fi(:,t)'*thetap(:,t)));
    thN(:,t) = theta(:,t) - E(:,:,t)*F'*L(:,t);
    
    e(t) = y(t) - fi(:,t)'*thN(:,t);
    
    
    B(:,:,t) = F*(I - K(:,t)*fi(:,t)');
    r(:, t-1) = B(:,:,t)'*r(:,t) + fi(:,t)*e(t)/s(t);
    R(:,:,t-1) = B(:,:,t)'*R(:,:,t)*B(:,:,t) + fi(:,t)*fi(:,t)'/s(t);
    
    
    EN(:,:,t) = Ep(:,:,t) - Ep(:,:,t)*R(:,:,t-1)*Ep(:,:,t);
    q = fi(:,t)'*EN(:,:,t)*fi(:,t);
    eo(t) = e(t) / (1 - q);
    ep(t) = e(t)/s(t) - K(:,t)'*F'*r(:,t);
end
th = thN;
warning on