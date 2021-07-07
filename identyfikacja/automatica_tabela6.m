clear all
N = 5000; r=2;beta = 1;
% ------------------ FIR ------------------------
% - - - - - - - A - - - - - - - -
% 
% W = zeros(6,4);
% 
% 
% 
% [b1, b2] = parametry(N, 'A');
% for std = 0.05:0.05:0.3
%     id = int8(std/0.05)
%     for pow=1:10
%         th = [b1;b2];
%         u = idinput(N, 'prbs');
%         %u = randn(N,1);
% 
%         y = zeros(N, 1);
%         y_est = zeros(size(y));
% 
%         fi = zeros(2, N);
%         for t=r+1:N
%             y(t) = b2(t) * u(t-2) + b1(t) * u(t-1);
%             if(beta == 1)
%                 y(t) = L(y(t), 0,std);
%             elseif(beta == 2)
%                 y(t) = y(t) + std*randn(1);
%             elseif(beta == 0)
%                 y(t) = U(y(t), 0,std);
%             end
%             
%             fi(:,t) = [u(t-1);u(t-2)];
%         end
%         fi = [0, u(1:N-1)'; 0,0, u(1:N-2)'];
% 
%         [th1, yo1, yp1] = EWLS(fi, y, lambda(6));
%         W(id, 1) =  W(id, 1)  + blad(th, th1);
%         [th2, yo2, yp2] = EWLS(fi, y, lambda(18));
%         W(id, 2) =W(id, 2) +blad(th, th2);
%         [th3, yo3, yp3] = EWLS(fi, y, lambda(54));
%         W(id, 3) = W(id, 3) +blad(th, th3);
% 
%         thc = C1(th1, th2, th3, yo1, yo2, yo3, beta);
%         W(id, 4) = W(id, 4) + blad(th, thc);
%     end
% end
% W = W./pow;
% formatuj(W);
% save 'tabela4_FIR_A', W;
% - - - - - - - B - - - - - - -

W = zeros(6,4);

        [b1, b2] = parametry(N, 'B');
for std = 0.05:0.05:0.3
    id = int8(std/0.05)
    for pow=1:3
        th = [b1;b2];
        u = idinput(N, 'prbs');
        %u = randn(N,1);

        y = zeros(N, 1);
        y_est = zeros(size(y));

        fi = zeros(2, N);
        for t=r+1:N
            y(t) = b2(t) * u(t-2) + b1(t) * u(t-1); 
            if(beta == 1)
                y(t) = L(y(t), 0,std);
            elseif(beta == 2)
                y(t) = y(t) + std*randn(1);
            elseif(beta == 0)
                y(t) = U(y(t), 0,std);
            end
            
            fi(:,t) = [u(t-1);u(t-2)];
        end

        fi = [0, u(1:N-1)'; 0,0, u(1:N-2)'];

        [th1, yo1, ep1] = EWLS(fi, y, lambda(6));
        W(id, 1) =  W(id, 1)  + blad(th, th1);
        [th2, yo2, ep2] = EWLS(fi, y, lambda(18));
        W(id, 2) =W(id, 2) +blad(th, th2);
        [th3, yo3, ep3] = EWLS(fi, y, lambda(54));
        W(id, 3) = W(id, 3) +blad(th, th3);

        thc = C1(th1, th2, th3, yo1, yo2, yo3, beta);
        W(id, 4) = W(id, 4) + blad(th, thc);
    end
end
W = W./pow;
formatuj(W);
save 'tabela4_FIR_B', W;

%------------------ AR ------------------------
% - - - - - - - A - - - - - - - -
% 
% W = zeros(1,4);
% 
% [b1, b2] = parametry(N, 'A');
% std = 0.1;
% id = 1;
% for pow=1:10
%     th = [b1;b2];
%     %u = idinput(N, 'prbs');
%     %u = randn(N,1);
% 
%     y = zeros(N, 1);
%     y_est = zeros(size(y));
% 
%     fi = zeros(2, N);
%     for t=r+1:N
%         y(t) = b2(t) * y(t-2) + b1(t) * y(t-1) + std* randn(1);
%         fi(:,t) = [y(t-1);y(t-2)];
%     end
% 
%     fi = [0, y(1:N-1)'; 0,0, y(1:N-2)'];
% 
%     [th1, yo1, yp1] = SWLS(fi, y, (30));
%     W(id, 1) =  W(id, 1)  + blad(th, th1);
%     [th2, yo2, yp2] = SWLS(fi, y, (60));
%     W(id, 2) =W(id, 2) +blad(th, th2);
%     [th3, yo3, yp3] = SWLS(fi, y, (120));
%     W(id, 3) = W(id, 3) +blad(th, th3);
% 
%     thc = C1(th1, th2, th3, yp1, yp2, yp3);
%     W(id, 4) = W(id, 4) + blad(th, thc);
% end
% W = W./pow;
% formatuj(W);


% - - - - - - - B - - - - - - -
% 
% W = zeros(1,4);
% 
% [b1, b2] = parametry(N, 'B');
% std = 0.1;
% id = 1;
% for pow=1:10
%     th = [b1;b2];
%     %u = idinput(N, 'prbs');
%     %u = randn(N,1);
% 
%     y = zeros(N, 1);
%     y_est = zeros(size(y));
% 
%     fi = zeros(2, N);
%     for t=r+1:N
%         y(t) = b2(t) * y(t-2) + b1(t) * y(t-1) + std* randn(1);
%         fi(:,t) = [y(t-1);y(t-2)];
%     end
% 
%     fi = [0, y(1:N-1)'; 0,0, y(1:N-2)'];
% 
%     [th1, yo1, yp1] = SWLS(fi, y, (30));
%     W(id, 1) =  W(id, 1)  + blad(th, th1);
%     [th2, yo2, yp2] = SWLS(fi, y, (60));
%     W(id, 2) =W(id, 2) +blad(th, th2);
%     [th3, yo3, yp3] = SWLS(fi, y, (120));
%     W(id, 3) = W(id, 3) +blad(th, th3);
% 
%     thc = C1(th1, th2, th3, yp1, yp2, yp3);
%     W(id, 4) = W(id, 4) + blad(th, thc);
% end
% W = W./pow;
% formatuj(W);
% 
