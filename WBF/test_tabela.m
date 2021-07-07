s = RandStream('mcg16807','Seed',0);
RandStream.setDefaultStream(s);
clc
clear all
close all
N = 5000;
T = 1:N;

beta = 2;
r = 2;


P = 50;


M = 21;

wyniki = [];
for sv = 0.05:0.05:0.3
    disp(sprintf('sv: %2.2f', sv))
    for p=1:P
        tic;
        [fi, y, th] = generuj('A', sv, beta);
        
        disp(sprintf('P: %d', p));
        
        % ------------------------------------------------------
        
        [thcomp, etapm] = th_comp(fi, y, M, beta);
        
        % ------------------------------------------------------
        [th11, eo11] = wbf_smoother(fi, y, lambda1(10),1);
        [th12, eo12] = wbf_smoother(fi, y, lambda1(30),1);
        [th13, eo13] = wbf_smoother(fi, y, lambda1(90),1);
        
        [th21, eo21] = wbf_smoother(fi, y, lambda2(10),2);
        [th22, eo22] = wbf_smoother(fi, y, lambda2(30),2);
        [th23, eo23] = wbf_smoother(fi, y, lambda2(90),2);
        
        [th31, eo31] = wbf_smoother(fi, y, lambda3(10),3);
        [th32, eo32] = wbf_smoother(fi, y, lambda3(30),3);
        [th33, eo33] = wbf_smoother(fi, y, lambda3(90),3);
        
        e = zeros(9,N);
        ep = zeros(9,N);
        thf = zeros([size(th), 9]);
        
        e(1, :) = eo11';
        e(2, :) = eo12';
        e(3, :) = eo13';
        
        e(4, :) = eo21';
        e(5, :) = eo22';
        e(6, :) = eo23';
        
        e(7, :) = eo31';
        e(8, :) = eo32';
        e(9, :) = eo33';
        
        
        thf(:,:,1) = th11;
        thf(:,:,2) = th12;
        thf(:,:,3) = th13;
        
        thf(:,:,4) = th21;
        thf(:,:,5) = th22;
        thf(:,:,6) = th23;
        
        thf(:,:,7) = th31;
        thf(:,:,8) = th32;
        thf(:,:,9) = th33;
        
        %[thc1, mk1] = med(thf(:,:,1:3), e(1:3,:), beta);
        [thc, mk] = med(thf, e, beta);
        
        % ------------------------------------------------------
        %
        h = ones(1, M);
        %         eo = mk(1,:).*eo1' + mk(2,:).*eo2' + mk(3,:).*eo3' + mk(4,:).*eo4' + mk(5,:).*eo5' + mk(6,:).*eo6';
        %         eo = abs(eo).^2;
        %         etao = filter2(h, eo);
        %         etao = etao.^(-M/beta);
        %
        %         micoop = etao ./ (etao + etapm2);
        %         micomp = etapm2 ./ (etao + etapm2);
        %
        %
        %         th_cc = zeros(size(th));
        %         th_cc(1,:) = thc(1,:).*micoop + thcomp2(1,:).*micomp;
        %         th_cc(2,:) = thc(2,:).*micoop + thcomp2(2,:).*micomp;
        
        % -------------------------
        
        eo1 = mk(1,:).*eo11' + mk(2,:).*eo12' + mk(3,:).*eo13' + ...
            mk(4,:).*eo21' + mk(5,:).*eo22' + mk(6,:).*eo23' + ...
            mk(7,:).*eo31' + mk(8,:).*eo32' + mk(9,:).*eo33';
        
        eo1 = abs(eo1).^beta;
        etao1 = filter2(h, eo1);
        etao1 = etao1.^(-M/beta);
        
        micoop1 = etao1 ./ (etao1 + etapm);
        micomp1 = etapm ./ (etao1 + etapm);
        
        
        th_cc = zeros(size(th));
        th_cc(1,:) = thc(1,:).*micoop1 + thcomp(1,:).*micomp1;
        th_cc(2,:) = thc(2,:).*micoop1 + thcomp(2,:).*micomp1;
        
        % --------------------------
        
        W = zeros(1, 12);
        
        W(1) = blad(th, th11);
        W(2) = blad(th, th12);
        W(3) = blad(th, th13);
        W(4) = blad(th, th21);
        W(5) = blad(th, th22);
        W(6) = blad(th, th23);
        W(7) = blad(th, th31);
        W(8) = blad(th, th32);
        W(9) = blad(th, th33);
        
        W(10) = blad(th, thc);
        W(11) = blad(th, thcomp);
        W(12) = blad(th, th_cc);
        
        % -----------------------------------------------------
        if(p==1)
            wyniki = [wyniki; W];
        else
            wyniki(end,:) = wyniki(end,:) + W;
        end
        toc
    end % koniec pętli powtórzeń
end % koniec pętli szumów
wyniki = wyniki / P;

file = sprintf('%s_P_%d.mat', datestr(now, 'yyyy_mm_dd_HH_MM'), P);
save(file, 'wyniki')

[x ec] = blad(th, thc);
[x ecomp] = blad(th, thcomp);
[x ecc] = blad(th, th_cc);


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
plot(thc(1, :), 'b')
plot(thcomp(1,:), 'g')
plot(th_cc(1,:), 'r')
legend('\theta', 'A', 'B', 'C')

