close all
clear all
N = 5000;
T = 1:N;
warning off;

[b1, b2] = parametry(N, 'A');
b1 = 3*ones(size(b1));
b2 = 2*ones(size(b2));

th = [b1;b2];
beta = 1;
r = 2;

wyniki = zeros(6, 5);
y(1) = 0.02*randn(1);
y(2) = 0.02*randn(1);
id = 1;
for sigma = 0.05 : 0.05 :0.3
    id = uint8(sigma/0.05);
    for pow = 1:1
        % u = randn(N, 1);
        u = idinput(N, 'prbs');
        y = zeros(N, 1);
        y_est = zeros(size(y));


        for t=3:N
             y(t)= b1(t)*u(t-1)+b2(t)*u(t-2);
            fi(:,t) = [y(t-1); y(t-2)];
        end
        ref = std(y);
        y = y./ref + sigma*randn(size(y));
       % y = L(y, 0, ref*sigma);
        e = zeros(3, N);
       % fi = [0, u(1:N-1)'; 0,0,u(1:N-2)'];
        
        
        
       [th1, e1] = EWLS_1s(fi,y,lambdaone(6));
       [th2, e2] = EWLS_1s(fi,y,lambdaone(18));
       [th3, e3] = EWLS_1s(fi,y,lambdaone(54));
%         
%          [th1, e1] = EWLS(fi, y, lambda(6));
%          [th2, e2] = EWLS(fi, y, lambda(90));
%          [th3, e3] = EWLS(fi, y, lambda(120));
        
        wyniki(id, 1) = wyniki(id, 1) + blad(th, th1);
        wyniki(id, 2) = wyniki(id, 2) + blad(th, th2);
        wyniki(id, 3) = wyniki(id, 3) + blad(th, th3);
        
        TH = zeros([size(th), 3]);
        TH(:,:,1) = th1;
        TH(:,:,2) = th2;
        TH(:,:,3) = th3;
        
        e = [e1,e2,e3]';
        
        %thc = medley(TH, e , beta);
        thc = C1(th1, th2, th3, e1, e2, e3, 2);
        
        
        wyniki(id, 4) = wyniki(id,4) + blad(th, thc);
       
    end
    end

    formatuj(wyniki/(pow*25))