    close all
    [fi, y, th] = generuj('A', 0.1, 2);
    N = length(y);
% ------ LMS -----
I = diag(ones(2,1));

m = mi(40, 1.0);
the = zeros(size(th));
thx = zeros(size(th));
e = zeros(size(y));

Rf = zeros(2,2,N);
rf = zeros(size(fi));


for t=2:N
   e(t) = y(t) - fi(:,t)'*the(:,t-1);
   the(:, t) = the(:,t-1) + m*fi(:,t)*e(t);
    
    Rf(:,:,t) = I - m*fi(:,t)*fi(:,t)';
    rf(:,t) = m*fi(:,t)*y(t);
    thx(:,t) = Rf(:,:,t)*thx(:,t-1) + rf(:,t);
    
end

thep = zeros(size(th));
thep(:,N) = the(:,N);

thewp = zeros(size(th));
thewp(:,N) = the(:,N);

R = zeros(size(Rf));
r = zeros(size(rf));

for t = N-2:-1:1
    R(:,:,t) = (1-m)*R(:,:,t+1) + m*Rf(:,:,t);
    r(:,t) = (1-m)*r(:,t+1) + m*rf(:,t); 
   
    thep(:,t) = (1-m)*thep(:,t+1) + (m)*the(:,t);
    thx(:,t) = R(:,:,t)*thx(:,t+1) + r(:,t);
    
end

th2 = EWLS_S(fi, y, lambda(40));

%thk = kalman_2s_v2(fi, y, sigmaw(40, 0.1), 0.1);

figure
subplot(2,1,1)
plot(th(1,:), 'k');
hold on
plot(thx(1,:), 'r');
plot(thep(1,:), 'b')

subplot(2,1,2)
plot(th(2,:), 'k');
hold on
plot(thep(2,:), 'b');
plot(th2(2,:), 'r');
%plot(thk(2,:), 'g');
legend('th', 'LMS', 'EWLS', 'Kalman')


% plot(thep(1,:), 'm');
% plot(th2(1,:), 'r');
% 
% % ------ WLS ----
% 
% lam = 0.9;
% th2 = zeros(size(th));
% e2 = zeros(size(y));
% K = zeros(size(th));
% P = zeros(2,2,N);
% 
% for t=2:N
%     K(:,t) = P(:,:,t-1)*fi(:,t) / (lam + fi(:,t)'*P(:,:,t-1)*fi(:,t));
%     P(:,:,t) = (1/lam)*(P(:,:,t-1) - (P(:,:,t-1)*fi(:,t)*fi(:,t)'*P(:,:,t-1))/(lam + fi(:,t)'*P(:,:,t-1)*fi(:,t)));
%     e2(t) = y(t) - fi(:,t)'*th2(:,t-1);
%     th2(:,t) = th2(:,t-1) + K(:,t)*e2(t);
% end
% plot(th2(1,:), 'r')