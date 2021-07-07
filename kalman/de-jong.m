

[fi, y, th, sv] = generuj('A', 0.1);

O = zeros(2,2);
N = length(y);
f1 = -1 * nad(2, 1);
f2 = 1*nad(2,2);
T = [-f1*I, -f2*I; I, O];
G = [I,O]';

X = [fi; zeros(size(fi))];

P = zeros(4,4,N);
b = zeros(size(X));
L = zeros(size(P));
K = zeros(size(X));
D = zeros(size(y));
e = zeros(size(y));


l = 50;
sw = 2*sv/(l^2);

kap = sw/sv;

for t=1:N-1
    K(:,t) = T*P(:,:,t)*X(:,t)' / D(t);
    L(:,:,t) = T - K(:,t)*X(:,t);
    D(t) = X(:,t)*P(:,:,t)*X(:,t)' + 1;
    
    e(t) = y(t) - X(:,t)*b(:,t);
    
    b(:,t+1) = T*b(:,t) + K(:,t)*e(t);    
    P(:,:,t+1) = L(:,:,t)*P(:,:,t)*T' + G*G'*kap^2; 
end


plot(th(1,:))
hold on
plot(X(1,:),'r')