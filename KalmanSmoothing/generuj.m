% Generates 2 types of trajectories (2 parameters):
% A - block-like parameters trajectories
% B - Chirp-like trajectories
%
% Input:
% typ - 'A' or 'B' 
% sv - selected noise STD
% beta - noise distribution parameter (use 2 for Gaussian noise, 1 for
% Laplacian noise)
%
% Output:
% fi - regression vector (vector of input variables)
% y - system output
% th - vector of original trajectories (without noise)

function [fi, y, th] = generuj(typ, sv, beta)
if(nargin<3)
    beta = 2;
end

N = 5000;

[b1, b2] = parametry(N, typ);

th = [b1;b2];
warning off
u = idinput(N, 'prbs'); % Pseudo-Random Binary Sequence
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


y = y + n;