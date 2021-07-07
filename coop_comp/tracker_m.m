function [am, em] = tracker_m(fi, y, sw, sv)

N = length(y);
am = zeros(size(fi));
apm = zeros(size(fi));

Vm = zeros(2,2,N);
Vm(:,:, 1) = diag([10,10]);
Vpm = zeros(size(Vm));

z = fi;
em = zeros(size(y));

k = sw/sv;
SIGMA = (k^2)*diag([1,1]);

for t=2:N
    
    Vpm(:,:,t) = Vm(:,:,t-1) + SIGMA;
    Vm(:,:,t) = Vpm(:,:,t) - (Vpm(:,:,t)*z(:,t)*z(:,t)'*Vpm(:,:,t))/(1 + z(:,t)'*Vpm(:,:,t)*z(:,t) );
    
    apm(:,t) = am(:,t-1);
    em(t) = y(t) - z(:,t)' * am(:,t-1);
    am(:,t) = am(:,t-1) + Vm(:,:,t) * z(:,t) * em(t);
    
end