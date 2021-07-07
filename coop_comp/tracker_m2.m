function [th, eo] = tracker_m2(fi, y, sw, sv)
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
Pf = zeros(4,4,N);
Ppf = zeros(size(P));
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

th = X;
eo = e;