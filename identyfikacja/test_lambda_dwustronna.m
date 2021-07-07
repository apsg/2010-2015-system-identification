
close all
clear all
N = 5000;
T = 1:N;

[b1, b2] = parametry(N, 'A');
th = [b1;b2];
beta = 1;
r = 2;

wyniki = zeros(6, 5);

id = 1;
 for sigma = 0.02 : 0.05 : 0.2
     id = uint8(sigma/0.05);
     for pow = 1:1
       % u = randn(N, 1);
        u = idinput(N, 'prbs');
        y = zeros(N, 1);
        y_est = zeros(size(y));
        
        
        for t=r+1:N
            % y(t)= b1(t)*u(t-1)+b2(t)*u(t-2);   
            y(t) = b2(t) * y(t-2) + b1(t) * y(t-1) + 0.2*randn(1);
            fi(:,t) = [y(t-1); y(t-2)];
        end
        ref = std(y);
        % y = y + ref*sigma*randn(size(y));
        y = L(y, 0, ref*sigma);
        e = zeros(3, N);
       % 
        %fi = [u(1:N)'; 0,u(1:N-1)'];
%         
%         [th1, fi1, ye1] = ident_lambdaf_FIR_dwustr(u, y, lambda(6));
%         [th2, fi2, ye2] = ident_lambdaf_FIR_dwustr(u, y, lambda(18));
%         [th3, fi3, ye3] = ident_lambdaf_FIR_dwustr(u, y, lambda(54));
%         

        [th1, eo1, ep1] = EWLS(fi, y, lambdaone(6));
        [th2, eo2, ep2] = EWLS(fi, y, lambdaone(18));
        [th3, eo3, ep3] = EWLS(fi, y, lambdaone(52));

        
%         [th1, f, ye1] = simplified_EWLS(fi, y, lambda(6));
%         [th2, f, ye2] = simplified_EWLS(fi, y, lambda(18));
%         [th3, f, ye3] = simplified_EWLS(fi, y, lambda(54));

        wyniki(id, 1) = wyniki(id, 1) + blad(th, th1);
        wyniki(id, 2) = wyniki(id, 2) + blad(th, th2);
        wyniki(id, 3) = wyniki(id, 3) + blad(th, th3);
        

        
        m = 10; M = 2*m+1;  % okno decyzyjne
        K = 3;              % liczba filtr�w
        
        h = ones(1, M);
        
        e(1, :) = eo1';
        e(2, :) = eo2';
        e(3, :) = eo3';
        
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
       
       
       
        disp(wyniki(1:id,:))
     end
 end
 
 wyniki = wyniki./pow;
 formatuj(wyniki);
 
%        wyniki(id, 4) = wyniki(id, 4) + sum((y(100:N-100) - yc3(100:N-100)).^2); 
%         
%         figure;
%         subplot(2,1,1)
%         plot(T, b1, 'k'), hold on
%         plot(T, th1(1,:), 'r--');
%         plot(T, th2(1,:), 'g:');
%         plot(T, th3(1,:), 'b-.');
%         title('b1'), legend('b1', 'estymator 1', 'estymator 2', 'estymator 3')
%         
%         subplot(2,1,2)
%         plot(T, b2, 'k'), hold on
%         plot(T, th1(2,:), 'r:')
%         plot(T, th2(2,:), 'g--')
%         plot(T, th3(2,:), 'b-.')
%         title('b2'), legend('b2', 'estymator 1', 'estymator 2', 'estymator 3')
%         
%         figure;
%         subplot(2,1,1)
%         plot(T, b1, 'k'), hold on
%         plot(T, a1_c3, 'r');
%         title('b1'), legend('b1', 'b1 est')
%         
%         subplot(2,1,2)
%         plot(T, b2, 'k'), hold on
%         plot(T, b1_c3, 'r')
%         title('b2'), legend('b2', 'b2 est')
%         
%         figure;
%         subplot(2,1,1), plot(T,y)
%         hold on
%         subplot(2,1,1),
%         plot(T, yc3, 'k')
%         legend('Y', 'oszacowanie Y')
%         
%         subplot(2,1,2), plot( T, (y - yc3).^2), legend('Kwadrat bledu')
%         
%         figure, title('Uzycie poszczegolnych estymatorow')
%         subplot(4,1,1), plot(b1) 
%         subplot(4,1,2), plot(mk(1,:)) 
%         set(gca, 'YLim', [-0.05, 1.05])
%         subplot(4,1,3), plot(mk(2,:)) 
%         set(gca, 'YLim', [-0.05, 1.05])
%         subplot(4,1,4), plot(mk(3,:)) 
%         set(gca, 'YLim', [-0.05, 1.05])
%         
%         figure;
%         subplot(3,1,1)
%         plot(esum(1, :))
%         set(gca, 'YLim', [0, 1])
%         subplot(3,1,2)
%         plot(esum(2, :))
%         set(gca, 'YLim', [0, 1])
%         subplot(3,1,3)
%         plot(esum(3, :))
%         set(gca, 'YLim', [0, 1])
%     end
% end
% 
% wyniki = wyniki / pow;
% for i=1:size(wyniki,1) 
%     disp(sprintf('%1.2f \t %2.3f \t %2.3f \t %2.3f \t %2.3f', 0.05*i, wyniki(i,:)))
% end