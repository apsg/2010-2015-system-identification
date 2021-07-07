sim_art2;



[x1,s1, eo1] = cv(history, msr, r, fi);
[x2,s2, eo2] = ca(history, msr, r, fi);

eo1(isnan(eo1)) = eps;
eo2(isnan(eo2)) = eps;

m = 10;
M = 2*m +1;

N = length(r);

D1 = zeros(2,2,N);
D2 = zeros(2,2,N);

psi1 = zeros(size(r));
psi2 = zeros(size(r));

warning off
for t = 1:N
    
    p = max(1, t-10);
    k = min(N, t+10);
    
    D1(:,:,t) = eo1(:,p:k)*eo1(:,p:k)';
    D2(:,:,t) = eo2(:,p:k)*eo2(:,p:k)';
    
    psi1(t) = (det(D1(:,:,t))).^(-M/2);
    psi2(t) = (det(D2(:,:,t))).^(-M/2);
    
    mi1 = psi1./(psi1+psi2);
    mi2 = psi2./(psi1+psi2);
    
end
warning on

s = zeros(size(s1));

s(1,:) = mi1'.*s1(1,:) + mi2'.*s2(1,:);
s(2,:) = mi1'.*s1(2,:) + mi2'.*s2(2,:);


figure;
plot(history(1,:), history(2,:), 'k')
hold on
plot(s(1,5:end-5), s(2,5:end-5), 'r')
hold on
plot(s1(1,5:end-5), s1(2,5:end-5), 'g')
plot(s2(1,5:end-5), s2(2,5:end-5), 'b')
legend('trajectory','combined', 'CV', 'CA')



figure;
plot(rmse(history(1:2,:), s(1:2,:)), 'r')
hold on
plot(rmse(history(1:2,:), s1(1:2,:)), 'g')
plot(rmse(history(1:2,:), s2(1:2,:)), 'b')
ylabel('RMSE, position')
legend('combined', 'CV', 'CA')

