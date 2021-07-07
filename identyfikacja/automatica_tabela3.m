close all
clear all
N = 5000;
T = 1:N;

[b1, b2] = parametry(N, 'A');
th = [b1;b2];
beta = 1;
r = 2;

wyniki = zeros(1, 5);
y(1) = 0.02*randn(1);
y(2) = 0.02*randn(1);
id = 1;
%for sigma = 0.05 : 0.05 : 0.3
   % id = uint8(sigma/0.05);
    for pow = 1:1
        % u = randn(N, 1);
        u = idinput(N, 'prbs');
        y = zeros(N, 1);
        y_est = zeros(size(y));


        for t=3:N
           %  y(t)= b1(t)*u(t-1)+b2(t)*u(t-2);
            y(t) = b2(t) * y(t-2) + b1(t) * y(t-1) + L(0,0, 0.02);
            fi(:,t) = [y(t-1); y(t-2)];
        end
        ref = std(y);
        y = y + ref*0.2*randn(size(y));
       % y = L(y, 0, ref*sigma);
        e = zeros(3, N);
       % fi = [0, u(1:N-1)'; 0,0,u(1:N-2)'];
        
        
        
     %   [th1, f, ye1] = EWLS_1s(fi,y,lambdaone(6));
     %   [th2, f, ye2] = EWLS_1s(fi,y,lambdaone(18));
     %   [th3, f, ye3] = EWLS_1s(fi,y,lambdaone(54));
        
         [th1, ye1] = EWLS(fi, y, lambda(6));
         [th2, ye2] = EWLS(fi, y, lambda(90));
         [th3, ye3] = EWLS(fi, y, lambda(120));
        
        wyniki(id, 1) = wyniki(id, 1) + blad(th, th1);
        wyniki(id, 2) = wyniki(id, 2) + blad(th, th2);
        wyniki(id, 3) = wyniki(id, 3) + blad(th, th3);
        

        
        m = 10; M = 2*m+1;  % okno decyzyjne
        K = 3;              % liczba filtr�w
        
        h = ones(1, M);
        
        e(1, :) = ye1';
        e(2, :) = ye2';
        e(3, :) = ye3';
        
        for i=1:3
            esum(i,:) = filter2(h, abs(e(i,:)).^beta);
        end
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
        
        
        a1_c3 = th1(1,:).*mk(1,:) + th2(1,:).*mk(2,:) + th3(1,:).*mk(3,:);
        b1_c3 = th1(2,:).*mk(1,:) + th2(2,:).*mk(2,:) + th3(2,:).*mk(3,:);
        
        
        thc = [a1_c3; b1_c3];
       wyniki(id, 4) = wyniki(id,4) + blad([b1;b2], thc);
       
       
        m = 10; M = 2*m+1;  % okno decyzyjne
        K = 3;              % liczba filtr�w
        
        h = ones(1, M);
        
        e(1, :) = ep1';
        e(2, :) = ep2';
        e(3, :) = ep3';
        
        for i=1:3
            esum(i,:) = filter2(h, abs(e(i,:)).^beta);
        end
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
        
        
        a1_c3 = th1(1,:).*mk(1,:) + th2(1,:).*mk(2,:) + th3(1,:).*mk(3,:);
        b1_c3 = th1(2,:).*mk(1,:) + th2(2,:).*mk(2,:) + th3(2,:).*mk(3,:);
        
        
        thc = [a1_c3; b1_c3];
       wyniki(id, 5) = wyniki(id,5) + blad([b1;b2], thc);
       
  %  end
    end

    formatuj(wyniki/(pow*25))