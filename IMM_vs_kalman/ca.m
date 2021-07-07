function [xN,sN, eo] = ca(history, msr, r, fi)

T = 1;
F = [1 0 T 0 T^2/2 0;
    0 1 0 T 0 T^2/2;
    0 0 1 0 T 0;
    0 0 0 1 0 T;
    0 0 0 0 1 0;
    0 0 0 0 0 1 ];

G = [ T^3/6 0;
    0 T^3 / 6;
    T^2/2 0;
    0 T^2 / 2;
    T 0;
    0 T];

H = [1 0 0 0 0 0;
    0 1 0 0 0 0];

N = length(r);

y = msr;
e = zeros(size(y));
x = zeros(6,N);
xp = x;
Q = zeros(2,2,N);
K = zeros(6,2,N);
P = zeros(6,6,N);
Pp = P;

P(:,:,1) = diag(10*ones(6,1));

J = zeros(2,2,N);
V = zeros(2,2,N);
Vp = [15^2,0 ; 0  0.002^2];
%Vp = diag([50,50].^2);

xp(:,1) = [29500; 35000; -250; -210; 0; 0];
x = xp;

for t=2:N
    e(:,t) = y(:,t) - H*xp(:,t-1);
    J(:,:,t) = [sin(fi(t)) r(t)*cos(fi(t));
        cos(fi(t)) -r(t)*sin(fi(t))];
    V(:,:,t) = J(:,:,t)*Vp*J(:,:,t)';
    %V(:,:,t) = Vp;
    Q(:,:,t) = H*Pp(:,:,t-1)*H' + V(:,:,t);
    K(:,:,t) = Pp(:,:,t-1)*H'/(Q(:,:,t));
    x(:,t) = xp(:, t-1) + K(:,:,t)*e(:,t);
    P(:,:,t) = Pp(:,:,t-1) - K(:,:,t)*Q(:,:,t)*K(:,:,t)';
    xp(:,t) = F*x(:,t);
    Pp(:,:,t) = F*P(:,:,t)*F' + G * diag([9,9]) * G';
end

Fb = inv(F);
Gb = -Fb*G;

xpb = zeros(size(xp));
xb = zeros(size(x));
Qb = zeros(size(Q));
Kb = zeros(size(K));
Pb = zeros(size(P));
Ppb = zeros(size(Pp));
eb = zeros(size(y));
xpb(:,N) = xp(:,N);
PN = zeros(size(P));
xN = zeros(size(x));


% pomocnicze wielkości do obliczania wag
eo = zeros(size(y));
SN = zeros(2,2);

sN = zeros(size(y));
warning off;
for t=N-1:-1:1
    % filtracja wsteczna
    eb(:,t) = y(:,t) - H*xpb(:,t+1);
    
    Qb(:,:,t) = H*Ppb(:,:,t+1)*H' + V(:,:,t);
    Kb(:,:,t) = Ppb(:,:,t+1)*H'/(Qb(:,:,t));
    xb(:,t) = xpb(:, t+1) + Kb(:,:,t)*eb(:,t);
    Pb(:,:,t) = Ppb(:,:,t+1) - Kb(:,:,t)*Qb(:,:,t)*Kb(:,:,t)';
    xpb(:,t) = Fb*xb(:,t);
    Ppb(:,:,t) = Fb*Pb(:,:,t)*Fb' + Gb * diag([9,9]) * Gb';
    
    % wygładzanie
    PN(:,:,t) = inv( inv(P(:,:,t)) + inv(Ppb(:,:,t+1)));
    xN(:,t) = PN(:,:,t) * ( inv(P(:,:,t))*x(:,t) + inv(Ppb(:,:,t+1))*xpb(:,t+1));
    
    
    % błędy wydrązone
    sN(:,t) = H*xN(:,t);
    e = y(t) - sN(:,t);
    SN = H*PN(:,:,t)*H';
    Sig = diag([1,1]) - SN/(V(:,:,t));
    eo(:,t) = (Sig)\e;
    
    
end
warning on
% 
% figure;
% plot(history(1,:), history(2,:), 'k')
% hold on
% plot(x(1,:), x(2,:), 'b')
% hold on
% plot(xb(1,10:end-10), xb(2,10:end-10), 'g')
% plot(xN(1,10:end-10), x(2,10:end-10), 'r')
% legend('trajectory','tracking forward', 'tracking backward', 'smoothing')
% 
% 
% figure;
% subplot(2,1,1),
% plot(rmse(history(1:2,:), x(1:2,:)))
% hold on
% plot(rmse(history(1:2,:), xb(1:2,:)), 'g')
% plot(rmse(history(1:2,:), xN(1:2,:)), 'r')
% ylabel('RMSE, position')
% legend('tracking forward', 'tracking backward', 'smoothing')
% 
% subplot(2,1,2)
% plot(rmse(history(3:4,:), x(3:4,:)))
% hold on
% plot(rmse(history(3:4,:), xb(3:4,:)), 'g')
% plot(rmse(history(3:4,:), xN(3:4,:)), 'r')
% ylabel('RMSE, velocity')
% legend('tracking forward', 'tracking backward', 'smoothing')
