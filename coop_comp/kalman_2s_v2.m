function [th, eo, ep, thp, thm] = kalman_2s_v2(fi, y, sw, sv)
warning off
W = diag([sw^2, sw^2]);

N = size(y);
P = zeros(2,2,N);
th = zeros(size(fi));

Pp = zeros(size(P));
Ppp = zeros(size(P));
Pm = zeros(size(P));
Pmp = zeros(size(P));

thp = zeros(size(fi));
thm = zeros(size(thp));
thpp = zeros(size(thp));
thmp = zeros(size(thp));

ep = zeros(size(y));
em = zeros(size(y));

kp = zeros(size(thm));
km = zeros(size(thm));

% war. pocz. 

Pm(:,:,1) = diag([10,10]);

% w przód => -

for t = 2:N
    Pmp(:,:,t) = Pm(:,:,t-1) + W;
    Pm(:,:,t) = Pmp(:,:,t) - (Pmp(:,:,t)*fi(:,t)*fi(:,t)'*Pmp(:,:,t))/(sv^2 + fi(:,t)'*Pmp(:,:,t)*fi(:,t));
    
    thmp(:,t) = thm(:,t-1);
    
    km(:,t) = Pmp(:,:,t)*fi(:,t) / (sv^2 + fi(:,t)'*Pmp(:,:,t)*fi(:,t));
    em(t) = y(t) - fi(:,t)'*thmp(:,t);
    thm(:,t) = thmp(:,t) + km(:,t)*em(t);
end

% w tył => +

for t = N-1:-1:1
    
    Ppp(:,:,t) = Pp(:,:,t+1) + W;
    Pp(:,:,t) = Ppp(:,:,t) - (Ppp(:,:,t)*fi(:,t)*fi(:,t)'*Ppp(:,:,t))/(sv^2 + fi(:,t)'*Ppp(:,:,t)*fi(:,t));
    
    thpp(:,t) = thp(:,t+1);
    
    kp(:,t) = Ppp(:,:,t)*fi(:,t) / (sv^2 + fi(:,t)'*Ppp(:,:,t)*fi(:,t));
    ep(t) = y(t) - fi(:,t)'*thpp(:,t);
    thp(:,t) = thpp(:,t) + kp(:,t)*ep(t);
end

Po = zeros(size(P));
tho = zeros(size(th));
e = zeros(size(y));
eo = zeros(size(y));
eo2 = zeros(size(y));
ep=zeros(size(y));

for t=1:N
    
    P(:,:,t) = inv(inv(Pmp(:,:,t)) + inv(Pp(:,:,t)));
    th(:,t) = P(:,:,t)*(Pmp(:,:,t)\thmp(:,t) + Pp(:,:,t)\thp(:,t));
    e(t) = y(t) - fi(:,t)'*th(:,t);
    
    Po(:,:,t) = inv(inv(Pmp(:,:,t)) + inv(Ppp(:,:,t)));
    tho(:,t) = Po(:,:,t) * (Pmp(:,:,t)\thmp(:,t) + Ppp(:,:,t)\thpp(:,t));
    eo(t) = y(t) - fi(:,t)' * tho(:,t);
    
    q = fi(:,t)'*P(:,:,t)*fi(:,t);
    
    eo2(t) = e(t) / (1 - q);
    ep(t) = e(t) *(1+q);
end
% disp('wewnatrz 1r2s')
% disp(blad(eo, eo2))
warning on