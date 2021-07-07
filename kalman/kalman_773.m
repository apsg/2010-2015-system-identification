function [th, eo] = kalman_773(fi, y, W)

if(size(W,1)<2)
    sigma = W;
    W = [W,0;0,W];
else
    sigma = 0.1;
end

sigma = 0.05;

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
    Pme(:,:,t) = Pmf(:,:,t) - (Pmf(:,:,t)*fi(:,t)*fi(:,t)'*Pmf(:,:,t))/(sigma + fi(:,t)'*Pmf(:,:,t)*fi(:,t));
    km(:,t) = Pmf(:,:,t)*fi(:,t) / (sigma + fi(:,t)'*Pmf(:,:,t)*fi(:,t));
    em(t) = y(t) - fi(:,t)'*them(:,t-1);
    them(:,t) = them(:,t-1) + km(:,t) * em(t); 
end

P = zeros(2,2,N);
Po = zeros(size(P));
Po2 = zeros(size(P));
Ppe = zeros(size(P));
Ppf = zeros(size(P));
thep = zeros(2, N);

for t=N-1:-1:1
    
    Ppf(:,:,t) = Ppe(:,:,t+1) + W;
    Ppe(:,:,t) = Ppf(:,:,t) - (Ppf(:,:,t)*fi(:,t)*fi(:,t)'*Ppf(:,:,t))/(sigma + fi(:,t)'*Ppf(:,:,t)*fi(:,t));
    kp(:,t) = Ppf(:,:,t)*fi(:,t) / (sigma + fi(:,t)'*Ppf(:,:,t)*fi(:,t));
    ep(t) = y(t) - fi(:,t)'*thep(:,t+1);
    thep(:,t) = thep(:,t+1) + kp(:,t) * ep(t); 
end

th = zeros(size(fi));
tho = zeros(size(th));
eo = zeros(size(y));
eo2 = zeros(size(y));
q = zeros(size(y));
e = zeros(size(y));

for t = 1:N
    P(:,:,t) = inv(inv(Pmf(:,:,t)) + inv(Ppe(:,:,t)));
    th(:,t) = P(:,:,t) * (inv(Pmf(:,:,t))*them(:,t) + inv(Ppe(:,:,t)) * thep(:,t));
    Po(:,:,t) = inv(inv(Pme(:,:,t)) + inv(Ppe(:,:,t)));
    tho(:,t) = Po(:,:,t) * (inv(Pmf(:,:,t))*them(:,t) + inv(Ppe(:,:,t))*thep(:,t));
    eo(t) = y(t) - fi(:,t)' * tho(:,t);

    
end

%disp(sum(abs(eo(100:N-100)-eo2(100:N-100))))
