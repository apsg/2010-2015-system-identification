close all
clear all
N = 5000;
T = 1:N;

[b1, b2] = parametry(N, 'B');
W = zeros(6,4);
r = 2;

for sigma = 0.05:0.05:0.3
    id = int8(sigma/0.05)
    for pow = 1:5

        u = randn(N, 1);
        u = idinput(N, 'prbs');
        y = zeros(N, 1);
        y_est = zeros(size(y));


        for t=r:N
            % y(t)= b1(t)*u(t-1)+b2(t)*u(t-2);
            y(t) = b2(t) * u(t-1) + b1(t) * u(t);
        end
        ref = std(y);
        %y = y + ref*sigma*randn(size(y));
        y = L(y, 0, ref*sigma);
        e = zeros(3, N);

        [th1, fi1, ye1] = ident_rectw_FIR(u, y, 6);
        [th2, fi2, ye2] = ident_rectw_FIR(u, y, 18);
        [th3, fi3, ye3] = ident_rectw_FIR(u, y, 54);

        th = [b1;b2];
        W(id,1) = W(id,1) + (blad(th, th1));
        W(id,2) = W(id,2) +(blad(th, th2));
        W(id,3) = W(id,3) +(blad(th, th3));

        m = 10; M = 2*m+1;  % okno decyzyjne
        K = 3;              % liczba filtr�w

        h = ones(1, M);

        e(1, :) = ye1';
        e(2, :) = ye2';
        e(3, :) = ye3';

        for i=1:3
            esum(i,:) = filter2(h, abs(e(i,:)).^1);
        end
        esum(esum ==0) = eps;
        psi = (-M/1) * log(esum);

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

        W(id,4) = W(id,4) +(blad(th, [a1_c3;b1_c3]));
        disp(W(1:id,:))
        %fi = [y(2:N)', 0; u(1:N)'];
        fi = [u(1:N)'; 0, u(1:N-1)'];

        yc3 = zeros(size(y));
        for i=1:N
            th = [a1_c3(i);
                b1_c3(i)];
            yc3(i) = fi(:,i)' * th;
        end

    end
    
end
W = W ./ pow;
formatuj(W);
%
% figure;
% subplot(2,1,1)
% plot(T, b1, 'k'), hold on
% plot(T, th1(1,:), 'r--');
% plot(T, th2(1,:), 'g:');
% plot(T, th3(1,:), 'b-.');
% set(gca, 'YLim', [-.5,1])
% title('a1'), legend('b1', 'estymator 1', 'estymator 2', 'estymator 3')
%
% pause();
%
% subplot(2,1,2)
% plot(T, b2, 'k'), hold on
% plot(T, th1(2,:), 'r:')
% plot(T, th2(2,:), 'g--')
% plot(T, th3(2,:), 'b-.')
% title('b1'), legend('b2', 'estymator 1', 'estymator 2', 'estymator 3')
%
% figure;
% subplot(2,1,1)
% plot(T, b1, 'k'), hold on
% plot(T, a1_c3, 'r--');
% set(gca, 'YLim', [-.5,1])
% title('a1'), legend('b1', 'b1 medley')
%
% subplot(2,1,2)
% plot(T, b2, 'k'), hold on
% plot(T, b1_c3, 'r:')
% title('b1'), legend('b2', 'b2 medley')
%
% figure;
% subplot(2,1,1), plot(T,y)
% hold on
% subplot(2,1,1),
% plot(T, yc3, 'k')
% legend('Y', 'oszacowanie Y')
%
% subplot(2,1,2), plot( T, (y - yc3).^2), legend('Kwadrat bledu')
%
% figure, title('Uzycie poszczegolnych estymatorow')
% subplot(4,1,1), plot(a1)
% subplot(4,1,2), plot(mk(1,:))
% set(gca, 'YLim', [-0.05, 1.05])
% subplot(4,1,3), plot(mk(2,:))
% set(gca, 'YLim', [-0.05, 1.05])
% subplot(4,1,4), plot(mk(3,:))
% set(gca, 'YLim', [-0.05, 1.05])
