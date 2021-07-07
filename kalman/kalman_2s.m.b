function [th, eo, ep] = kalman_2s(fi, y, sw, sv)
warning off

sv = sv^2;
W = diag([sw^2, sw^2]);

N = size(y);
P = zeros(2,2,N);
Pme = zeros(size(P));
Pmf = zeros(size(P));
them = zeros(2, N);

km = zeros(size(fi));

% predykcja w przód

em = zeros(size(y));


for t = 2:N
    Pmf(:,:,t) = Pme(:,:,t-1) + W;
    Pme(:,:,t) = Pmf(:,:,t) - (Pmf(:,:,t)*fi(:,t)*fi(:,t)'*Pmf(:,:,t))/(sv + fi(:,t)'*Pmf(:,:,t)*fi(:,t));
    km(:,t) = Pmf(:,:,t)*fi(:,t) / (sv + fi(:,t)'*Pmf(:,:,t)*fi(:,t));
    em(t) = y(t) - fi(:,t)'*them(:,t-1);
    them(:,t) = them(:,t-1) + km(:,t) * em(t); 
end

P = zeros(2,2,N);
Po = zeros(size(P));
Ppe = zeros(size(P));
Ppf = zeros(size(P));
thep = zeros(2, N);
ep = zeros(size(em));

for t=N-1:-1:1
    
    Ppf(:,:,t) = Ppe(:,:,t+1) + W;
    Ppe(:,:,t) = Ppf(:,:,t) - (Ppf(:,:,t)*fi(:,t)*fi(:,t)'*Ppf(:,:,t))/(sv + fi(:,t)'*Ppf(:,:,t)*fi(:,t));
    kp(:,t) = Ppf(:,:,t)*fi(:,t) / (sv + fi(:,t)'*Ppf(:,:,t)*fi(:,t));
    ep(t) = y(t) - fi(:,t)'*thep(:,t+1);
    thep(:,t) = thep(:,t+1) + kp(:,t) * ep(t); 
end

th = zeros(size(fi));
tho = zeros(size(th));
e = zeros(size(y));
eo = zeros(size(y));
eo2 = zeros(size(y));
ep2 = zeros(size(y));

for t = 1:N
    P(:,:,t) = inv(inv(Pmf(:,:,t)) + inv(Ppe(:,:,t)));
    th(:,t) = P(:,:,t) * ((Pmf(:,:,t))\them(:,t) + (Ppe(:,:,t)) \ thep(:,t));
    e(t) = y(t) - fi(:,t)' * th(:,t);

    Po(:,:,t) = inv(inv(Pme(:,:,t)) + inv(Ppe(:,:,t)));
    tho(:,t) = Po(:,:,t) * ((Pmf(:,:,t))\them(:,t) + (Ppe(:,:,t))\thep(:,t));
    eo(t) = y(t) - fi(:,t)' * tho(:,t);
    
    q = fi(:,t)'*P(:,:,t)*fi(:,t);
    
    eo2(t) = e(t) / (1 - q);
    ep2(t) = ep(t) *(1+q);
end

blad(eo, eo2)
