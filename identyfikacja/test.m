clear all
N = 5000; r=2;
% ------------------ FIR ------------------------
% - - - - - - - A - - - - - - - -
beta = 1;
W = zeros(6,4);
id=1;
[b1, b2] = parametry(N, 'A');

th = [b1;b2];
u = idinput(N, 'prbs');
%u = randn(N,1);

y = zeros(N, 1);
yn=zeros(N,1);
y_est = zeros(size(y));

fi = zeros(2, N);
for t=r+1:N
    y(t) = b2(t) * u(t-2) + b1(t) * u(t-1);
 
    fi(:,t) = [u(t-1);u(t-2)];
end
yn = L(y, 0, std(y)*0.2);
figure; plot(y), hold on, plot(yn, 'r')


fi = [0, u(1:N-1)'; 0,0, u(1:N-2)'];

[th1, yo1, yp1] = EWLS(fi, yn, lambda(6));
W(id, 1) =  W(id, 1)  + blad(th, th1);
[th2, yo2, yp2] = EWLS(fi, yn, lambda(18));
W(id, 2) =W(id, 2) +blad(th, th2);
[th3, yo3, yp3] = EWLS(fi, yn, lambda(54));
W(id, 3) = W(id, 3) +blad(th, th3);

[thc, mk] = C1(th1, th2, th3, yp1, yp2, yp3, beta);
W(id, 4) = W(id, 4) + blad(th, thc)

figure;
plot(th(1,:),'k')
hold on
plot(th1(1,:), 'r')
plot(th2(1,:), 'g')
plot(th3(1,:), 'b')
