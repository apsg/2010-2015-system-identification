

[fi, y, th, sv] = generuj('A', 0.1,2);

I = diag([1,1]);
O = zeros(2,2);
N = length(y);
f1 = -1 * nad(2, 1);
f2 = 1*nad(2,2);
T = [-f1*I, -f2*I; I, O];
G = [I,O]';

X = [fi; zeros(size(fi))]';

P = zeros(4,4,N);
b = zeros(4,N);
L = zeros(size(P));
K = zeros(4,N);
D = zeros(size(y));
e = zeros(size(y));


l = 50;
sw = 2*sv/(l^2);

kap = sw/sv;

for t=1:N-1
    D(t) = X(t,:)*P(:,:,t)*X(t,:)' + 1;
    K(:,t) = ( T*P(:,:,t)*X(t,:)' ) / D(t);
    L(:,:,t) = T - K(:,t)*X(t,:);
    
    e(t) = y(t) - X(t,:)*b(:,t);
    
    b(:,t+1) = T*b(:,t) + K(:,t)*e(t);
    P(:,:,t+1) = L(:,:,t)*P(:,:,t)*T' + G*G'*kap^2;
end

% ---- backward ----

m = zeros(size(b));
R = zeros(size(P));
B = zeros(size(b));

ef = zeros(size(y));
e2=zeros(size(y));
bet = zeros(size(y));

for t=N-1:-1:2
    
    m(:,t-1) = X(t,:)'*e(t)/D(t) + L(:,:,t)'*m(:,t);
    
    B(:,t) = b(:,t) + P(:,:,t)*m(:,t-1);
    
    e2(t) = y(t) - X(t,:)*B(:,t);
    ef(t) = e2(t) / D(t) - K(:,t)'*m(:,t);
    
end


% ---------------- spr

[th2, eo2, ep3] = kalman_2r2s(fi, y, sw, sv);
plot(eo2, 'm');

% ------------------
figure;
plot(th(1,:))
hold on
plot(B(1,:),'r')
plot(th2(1,:), 'g')


