function [ap, ep] = tracker_p(fi, y, sw, sv)

N = length(y);
ap = zeros(size(fi));
app = zeros(size(fi));

Vp = zeros(2,2,N);
Vp(:,:, 1) = diag([10,10]);
Vpp = zeros(size(Vp));

z = fi;
ep = zeros(size(y));

k = sw/sv;
SIGMA = (k^2)*diag([1,1]);

for t=N-1:-1:1
    
    Vpp(:,:,t) = Vp(:,:,t+1) + SIGMA;
    Vp(:,:,t) = Vpp(:,:,t) - (Vpp(:,:,t)*z(:,t)*z(:,t)'*Vpp(:,:,t))/(1 + z(:,t)'*Vpp(:,:,t)*z(:,t) );
    
    app(:,t) = ap(:,t+1);
    ep(t) = y(t) - z(:,t)' * ap(:,t+1);
    ap(:,t) = ap(:,t+1) + Vp(:,:,t) * z(:,t) * ep(t);
    
end