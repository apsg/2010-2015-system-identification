function [fi, y, th, sv, SN] = generuj(typ, sv, beta)
if(nargin<3)
    beta = 2;
end

N = 5000;

[b1, b2] = parametry(N, typ);

th = [b1;b2];
warning off
% u = randn(N, 1);
u = idinput(N, 'prbs');
y = zeros(N, 1);
warning on
fi = zeros(2,N);
for t=3:N
    %y(t)= b1(t)*u(t)+b2(t)*u(t-1) + L(0,0,0.05);
    y(t) = b2(t) * u(t-1) + b1(t) * u(t);
    fi(:,t) = [u(t);u(t-1)];
end
sv = std(y)*sv;
if(beta == 2)
    n = sv*randn(size(y));
elseif(beta == 1)
    n = L(y, 0, sv);
end
%disp(sprintf('SNR: %2.2f ', snr(y,n)))
SN = snr(y,n);

y = y + n;