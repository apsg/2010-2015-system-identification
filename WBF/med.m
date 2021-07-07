function [thc, mk] = med(th, e, beta)

if(nargin<3)
    beta = 2;
end

[I,J,K] = size(th);

    m = 15; M = 2*m+1;  % okno decyzyjne
  %  K = size(e,1);              % liczba filtrów
   
    h = ones(1, M);

    esum = zeros(size(e));
    for i=1:K
        esum(i,:) = filter2(h, abs(e(i,:)).^beta);
    end
%     
%     dzeta = esum.^(-M/beta);
%     dzetasum = sum(dzeta, 1);
%     mk = zeros(size(e));
%     for i=1:K
%         mk(i,:) = dzeta(i, :) ./ dzetasum;
%     end
    
    
    esum(esum ==0) = eps;
    psi = (-M/beta) * log(esum);

    psimax = max(psi, [],1);
    chi = zeros(size(psi));
    for i=1:K
        chi(i,:) = psi(i,:) - psimax;
    end
    chi = exp(chi);
    chisums = sum(chi,1);
    mk = zeros(size(e));
    for i=1:K
        mk(i,:) = chi(i,:)./ chisums;
    end

a1 = zeros(1,J);
a2 = zeros(1,J);

for i=1:K
    a1 = a1 + th(1,:,i).*mk(i,:);
    a2 = a2 + th(2,:,i).*mk(i,:);
end

thc = [a1;a2];
%rysuj_wagi(mk);

