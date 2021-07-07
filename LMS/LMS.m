function [th, eo] = LMS(fi, y, m)
N = length(y);

thf = zeros(size(fi));
e = zeros(size(y));

for t=2:N
    e(t) = y(t) - fi(:,t)'*thf(:,t-1);
    thf(:,t) = thf(:,t-1) + m*fi(:,t)*e(t);
end

th = zeros(size(thf));
th(:,N) = thf(:,N);
ee = zeros(size(e));
eo = zeros(size(e));
eo2 = zeros(size(e));

for t=N-1:-1:1
    th(:,t) = (1-m)*th(:,t+1) + m*thf(:,t);
    
    ee(t) = y(t) - fi(:,t)'*th(:,t);
    
    q = (m^2)*fi(:,t)'*fi(:,t);
    eo(t) = ee(t)*(1+q);
    eo2(t) = y(t) - fi(:,t)'*(th(:,t) - (m^2)*fi(:,t)*ee(t));
end
disp(sum(abs(eo(100:end-100) - eo2(100:end-100))))