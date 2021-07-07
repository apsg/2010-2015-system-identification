% test AR
N = 5000;

W = zeros(1,4);

[b1, b2] = parametry(N, 'A');
r = 2;
id = 1;
L = [];
e = [];
th = [b1;b2];

%u = idinput(N, 'prbs');
%u = randn(N,1);

y = zeros(N, 1);
y_est = zeros(size(y));
sigma = 1;
fi = zeros(2, N);
for t=r+1:N
    y(t) = b2(t) * y(t-2) + b1(t) * y(t-1) + sigma* randn(1);
    fi(:,t) = [y(t-1);y(t-2)];
end

n = 55;
[th2, yo1, yp1] = EWLS(fi, y, n);

plot(th(1,:))
hold on
plot(th2(1, :),'r')

thx = th2(:, 2301:3300);

S = zeros(2,2);
licz = 0;
mian = 0;

for i = 2301:3300
    S = S + fi(:,i)*fi(:,i)';
    w = lambda(n).^abs(3300-i);
    licz = licz + w;
    mian = mian + w.^2;
end
l = licz.^2 / mian;
lewa = cov(thx')
FIo = (1/size(thx,2))*S;

prawa = sigma *FIo / l
