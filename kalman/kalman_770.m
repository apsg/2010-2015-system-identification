function [th, eo] = kalman_770(fi, y, sw, sv)
N = length(y);
F = diag([1,1]);

E = zeros(2,2,N);
Ep = zeros(size(E));
theta = zeros(size(fi));
thetap = zeros(size(fi));
K = zeros(size(theta));
e = zeros(size(y));

E(:,:,1) = diag([10,10]);
I = diag([1 1]);
k = sw/sv;

for t=2:N
    Ep(:,:,t) = E(:,:,t-1) + diag([k^2, k^2]);
    E(:,:,t) = Ep(:,:,t) - Ep(:,:,t)*fi(:,t)*fi(:,t)'*Ep(:,:,t) / (1 + fi(:,t)'*Ep(:,:,t)*fi(:,t));
    
    K(:,t) = Ep(:,:,t)*fi(:,t) / (1 + fi(:,t)'*Ep(:,:,t)*fi(:,t));
    thetap(:,t) = F*theta(:,t-1);
    e(t) = y(t) - fi(:,t)'*thetap(:,t);
    theta(:,t) = thetap(:,t) + K(:,t)*e(t);
end

th2 = zeros(size(theta));

for t = N-1:-1:1
    A(:,:,t) = E(:,:,t) * F' *inv(Ep(:,:,t+1));
    th2(:,t) = theta(:,t) + A(:,:,t) *(th2(:,t+1) - thetap(:, t+1));
end

th= th2;
eo=e;