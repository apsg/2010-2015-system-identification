s = RandStream('mcg16807','Seed',0);
RandStream.setDefaultStream(s);

close all
N = 5000;
T = 1:N;
beta = 1;
r = 2;


P = 50;


M = 21;

wyniki = [];
for sv = 0.05:0.05:0.3
    disp(sprintf('sv: %2.2f', sv))
    for p=1:P
        [fi, y, th] = generuj('A', sv, beta);
        
        disp(sprintf('P: %d', p));
        
        % ------------------------------------------------------
        
        [thcomp, etapm, thcomp2, etapm2] = comp(fi, y, sv, M, beta);
        
        % ------------------------------------------------------
        [th1, eo1] = kalman_2s_v2(fi, y, sigmaw(10, sv), sv);
        [th2, eo2] = kalman_2s_v2(fi, y, sigmaw(30, sv), sv);
        [th3, eo3] = kalman_2s_v2(fi, y, sigmaw(90, sv), sv);
        [th4, eo4] = kalman_2r2s(fi, y, sigmaw2(10, sv), sv);
        [th5, eo5] = kalman_2r2s(fi, y, sigmaw2(30, sv), sv);
        [th6, eo6] = kalman_2r2s(fi, y, sigmaw2(90, sv), sv);
        
        
        e = zeros(6,N);
        ep = zeros(6,N);
        thf = zeros([size(th), 6]);
        
        e(1, :) = eo1';
        e(2, :) = eo2';
        e(3, :) = eo3';
        e(4, :) = eo4';
        e(5, :) = eo5';
        e(6, :) = eo6';
        
        thf(:,:,1) = th1;
        thf(:,:,2) = th2;
        thf(:,:,3) = th3;
        thf(:,:,4) = th4;
        thf(:,:,5) = th5;
        thf(:,:,6) = th6;
        
        [thc1, mk1] = kalmed(thf(:,:,1:3), e(1:3,:), beta);
        [thc, mk] = kalmed(thf, e, beta);
        
        % ------------------------------------------------------
        
        h = ones(1, M);
        eo = mk(1,:).*eo1' + mk(2,:).*eo2' + mk(3,:).*eo3' + mk(4,:).*eo4' + mk(5,:).*eo5' + mk(6,:).*eo6';
        eo = abs(eo).^beta;
        etao = filter2(h, eo);
        etao = etao.^(-M/beta);
        
        micoop = etao ./ (etao + etapm2);
        micomp = etapm2 ./ (etao + etapm2);
        
        
        th_cc = zeros(size(th));
        th_cc(1,:) = thc(1,:).*micoop + thcomp2(1,:).*micomp;
        th_cc(2,:) = thc(2,:).*micoop + thcomp2(2,:).*micomp;
        
        % -------------------------
        
        eo11 = mk1(1,:).*eo1' + mk1(2,:).*eo2' + mk1(3,:).*eo3';
        eo11 = abs(eo11).^beta;
        etao11 = filter2(h, eo11);
        etao11 = etao11.^(-M/beta);
        
        micoop1 = etao11 ./ (etao11 + etapm);
        micomp1 = etapm ./ (etao11 + etapm);
        
        
        th_cc1 = zeros(size(th));
        th_cc1(1,:) = thc1(1,:).*micoop1 + thcomp(1,:).*micomp1;
        th_cc1(2,:) = thc1(2,:).*micoop1 + thcomp(2,:).*micomp1;
        
        % --------------------------
        
        W = zeros(1, 12);
        
        W(1) = blad(th, th1);
        W(2) = blad(th, th2);
        W(3) = blad(th, th3);
        W(4) = blad(th, th4);
        W(5) = blad(th, th5);
        W(6) = blad(th, th6);
        
        W(7) = blad(th, thc1);
        W(8) = blad(th, thc);
        W(9) = blad(th, thcomp);
        W(10) = blad(th, thcomp2);
        W(11) = blad(th, th_cc1);
        W(12) = blad(th, th_cc);
        
        % -----------------------------------------------------
        if(p==1)
            wyniki = [wyniki; W];
        else
            wyniki(end,:) = wyniki(end,:) + W;
        end
    end % koniec pętli powtórzeń
end % koniec pętli szumów
wyniki = wyniki / P;

file = sprintf('%s_P_%d.mat', datestr(now, 'yyyy_mm_dd_HH_MM'), P);
save(file, 'wyniki')

[x ec] = blad(th, thc1);
[x ecomp] = blad(th, thcomp);
[x ecc] = blad(th, th_cc1);


figure; hold on
plot(th(1,:), 'k--');
xx = 101:4900;
plot(xx, ec, 'b');
plot(xx, ecomp, 'g')
plot(xx, ecc, 'r')
legend('\theta', 'K_{1-3}', 'C_{1-3}', 'K+C')

figure;
plot(th(1,:), 'k')
hold on
plot(thc1(1, :), 'b')
plot(thcomp(1,:), 'g')
plot(th_cc1(1,:), 'r')
legend('\theta', 'K_{1-3}', 'C_{1-3}', 'K+C')
