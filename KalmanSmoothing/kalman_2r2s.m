function [th, eo, ep] = kalman_2r2s(fi, y, sw, sv)
warning off

N = length(y);
kap = sw/sv;

I = diag([1,1]);
I4 = diag([1,1,1,1]);
O = zeros(2,2);

f1 = -1 * nad(2, 1);
f2 = 1*nad(2,2);
F = [-f1*I, -f2*I; I, O];
G = [I,O]';


FI = [fi; zeros(size(fi))];
W = I*sw^2;

X =zeros(size(FI));
Xp = zeros(size(FI));
e = zeros(size(y));
P = zeros(4,4,N);
Pp = zeros(size(P));
Pf = zeros(4,4,N);
Ppf = zeros(size(P));
s = zeros(size(e));
sf = zeros(size(e));
k = zeros(size(FI));

for t =2:N
   
    Xp(:,t) = F*X(:,t-1);
    Ppf(:,:,t) = F*Pf(:,:,t-1)*F' + G*G'*kap^2;
    e(t) = y(t) - FI(:,t)'*Xp(:,t);
    sf(t) = FI(:,t)'*Ppf(:,:,t)*FI(:,t) + 1;
    k(:,t) = Ppf(:,:,t)*FI(:,t) / sf(t);
    X(:,t) = Xp(:,t) + k(:,t) * e(t);
    Pf(:,:,t) =  Ppf(:,:,t) - k(:,t)*k(:,t)'*sf(t);
end

% ------------ RTS --------------------
% 
% A = zeros(4,4,N);
% PfN = zeros(size(Pf));
% XN = zeros(size(X));
% XN(:,N) = X(:,N);
% 
% for t = N-1:-1:1
%     A(:,:,t) = Pf(:,:,t)*F'/(Ppf(:,:,t+1));
%     PfN(:,:,t) = Pf(:,:,t) + A(:,:,t)*(PfN(:,:,t+1) - Ppf(:,:,t+1))*A(:,:,t)';
%     XN(:,t) = X(:,t) + A(:,:,t)*(XN(:,t+1) - Xp(:,t+1));
% end
% 
% th1 = XN(1:2, :);

% ------------ Bayes - Frasier formula -------------------

B = zeros(4,4,N);
r = zeros(size(FI));
R = zeros(size(B));
XN = zeros(size(X));
PfN = zeros(size(P));
ZN = zeros(size(y));
q = zeros(size(y));
eo = zeros(size(y));
ep = zeros(size(y));

ef=zeros(size(y));
eo2 = zeros(size(y));

b = zeros(size(y));

for t=N-1:-1:2
   B(:,:,t) = F*(I4 - k(:,t)*FI(:,t)'); 
   r(:,t-1) = B(:,:,t)'*r(:,t) + FI(:,t)*e(t)/sf(t);
   R(:,:,t-1) = B(:,:,t)' *R(:,:,t) * B(:,:,t) + FI(:,t)*FI(:,t)' / sf(t);
   
   % First option
   %PfN(:,:,t) = Pf(:,:,t) - Pf(:,:,t)*F'*R(:,:,t)*F*Pf(:,:,t);
   %XN(:,t) = X(:,t) + Pf(:,:,t)*F'*r(:,t);
   
   % second option
   PfN(:,:,t) = Ppf(:,:,t) - Ppf(:,:,t)*R(:,:,t-1)*Ppf(:,:,t);
   XN(:,t) = Xp(:,t) + Ppf(:,:,t)*r(:,t-1  );
   
   ZN(t) = FI(:,t)'*XN(:,t);
   e2(t) = y(t) - ZN(t);
   q(t) = FI(:,t)' * PfN(:,:,t) * FI(:,t);
   eo(t) = e2(t) / (1-q(t));
   
   ef(t) = e(t) / sf(t) - k(:,t)'*F'*r(:,t);
   
   b(t) = 1/sf(t) + k(:,t)'*F'*R(:,:,t)*F*k(:,t);
   eo2(t) = ef(t) / b(t);
   
   ep(t) = e(t) *(1+q(t));
end
th = XN(1:2, :);


warning on
