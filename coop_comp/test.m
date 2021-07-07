s = RandStream('mcg16807','Seed',0);
RandStream.setDefaultStream(s);

close all
N = 5000;
T = 1:N;
beta = 2;
r = 2;

sv = 0.10;

P = 10;
wyniki =zeros(P,2);
trajektorie = zeros(2,N,P);

[fi, y, th] = generuj('B', sv);


% -----------------------------------------

% [am, emo] = tracker_m(fi, y, sigmaw(30, sv), sv);
% [ap, epo] = tracker_p(fi, y, sigmaw(30, sv), sv);
% 
% em2 = emo.^2;
% ep2 = epo .^2;
% 
% M = 21;
% h = ones(2*M - 1, 1);
% h(M+1:end) = 0;
% 
% Im = filter2(h, em2);
% 
% h = ones( 2*M - 1, 1);
% h(1:M-1) = 0;
% 
% Ip = filter2(h, ep2);
% 
% [x I] = min([Im'; Ip'], [], 1);
% ac = zeros(size(am));
% 
% a = zeros([size(am), 2]);
% a(:,:,1) = am;
% a(:,:,2) = ap;
% 
% for i=1:N
%     ac(:, i) = a(:,i,I(i));
% end
% 
% % ---------------------------------------------
% 
% mip = Ip.^(-M/2);
% mip(mip==Inf) = eps;
% mim = Im.^(-M/2);
% mim(mim==Inf) = eps;
% 
% misum = sum([mip mim], 2);
% 
% mim = mim./misum;
% mip = mip./misum;
% 
% 
% acomp(1,:) = am(1,:).*mim' + ap(1,:).*mip';
% acomp(2,:) = am(2,:).*mim' + ap(2,:).*mip';

% ---------------------------------------------

% [thcomp spr]= th_comp(fi, y, sv);
% 
% 
% K=3;
% 
% [am1, emo1] = tracker_m(fi, y, sigmaw(10, sv), sv);
% [ap1, epo1] = tracker_p(fi, y, sigmaw(10, sv), sv);
% 
% [am2, emo2] = tracker_m(fi, y, sigmaw(30, sv), sv);
% [ap2, epo2] = tracker_p(fi, y, sigmaw(30, sv), sv);
% 
% [am3, emo3] = tracker_m(fi, y, sigmaw(90, sv), sv);
% [ap3, epo3] = tracker_p(fi, y, sigmaw(90, sv), sv);
% 
% em1 = emo1.^2;
% em2 = emo2.^2;
% em3 = emo3.^2;
% ep1 = epo1.^2;
% ep2 = epo2.^2;
% ep3 = epo3.^2;
% 
M = 21;
% 
% h = ones(2*M - 1, 1);
% h(M+1:end) = 0;
% 
% Im1 = filter2(h, em1);
% Im2 = filter2(h, em2);
% Im3 = filter2(h, em3);
% 
% h = ones(2*M - 1, 1);
% h(1:M-1) = 0;
% 
% Ip1 = filter2(h, ep1);
% Ip2 = filter2(h, ep2);
% Ip3 = filter2(h, ep3);
% 
% mip1 = Ip1.^(-M/2);
% mip2 = Ip2.^(-M/2);
% mip3 = Ip3.^(-M/2);
% 
% mim1 = Im1.^(-M/2);
% mim2 = Im2.^(-M/2);
% mim3 = Im3.^(-M/2);
% 
% misum = sum([mim1 mim2 mim3 mip1 mip2 mip3], 2);
% 
% mip1 = (mip1./misum)';
% mip2 = (mip2./misum)';
% mip3 = (mip3./misum)';
% mim1 = (mim1./misum)';
% mim2 = (mim2./misum)';
% mim3 = (mim3./misum)';
% 
% spr = mip1 + mip2 + mip3 + mim1 + mim2 + mim3;
% 
% thcomp(1,:) = ...
%     mim1.*am1(1,:) + mim2.*am2(1,:) + mim3.*am3(1,:) + ...
%     mip1.*ap1(1,:) + mip2.*ap2(1,:) + mip3.*ap3(1,:);
% 
% thcomp(2,:) = ...
%     mim1.*am1(2,:) + mim2.*am2(2,:) + mim3.*am3(2,:) + ...
%     mip1.*ap1(2,:) + mip2.*ap2(2,:) + mip3.*ap3(2,:);

[thcomp, etapm, thcomp2, etapm2, am, ap] = comp(fi, y, sv, M, beta);

% ------------------------------------------------------


[th1, eo1] = kalman_2s_v2(fi, y, sigmaw(10, sv), sv);
[th2, eo2, ep, thp, thm] = kalman_2s_v2(fi, y, sigmaw(30, sv), sv);
[th3, eo3] = kalman_2s_v2(fi, y, sigmaw(90, sv), sv);


e = zeros(3,N);
ep = zeros(3,N);
thf = zeros([size(th), 3]);

e(1, :) = eo1';
e(2, :) = eo2';
e(3, :) = eo3';

thf(:,:,1) = th1;
thf(:,:,2) = th2;
thf(:,:,3) = th3;
[thc mk] = kalmed(thf, e);


% ------------------------------------------------------

h = ones(1, M);
eo = mk(1,:).*eo1' + mk(2,:).*eo2' + mk(3,:).*eo3';
eo = eo.^beta;
etao = filter2(h, eo);
etao = etao.^(-M/beta);

micoop = etao ./ (etao + etapm);
micomp = etapm ./ (etao + etapm);


th_cc = zeros(size(th));
th_cc(1,:) = thc(1,:).*micoop + thcomp(1,:).*micomp;
th_cc(2,:) = thc(2,:).*micoop + thcomp(2,:).*micomp;

% -----------------------------------------------------

figure;
plot(th(1,:), 'k')
hold on
plot(am(1,:), 'b')
plot(ap(1,:), 'g')
plot(thcomp(1,:), 'r')
legend('Original trajectory', 'Forward filter', 'Backward filter', 'Smoother')



figure;
plot(th(1,:), 'k')
hold on
plot(th1(1,:), 'b')
plot(th2(1,:), 'g')
plot(th3(1,:), 'c')
plot(thc(1,:), 'r')

figure;
plot(th(1,:), 'k--')
hold on
plot(thc(1,:), 'b')
plot(thcomp(1,:), 'g')
plot(th_cc(1,:),'r')
legend('Original trajectory', 'A - cooperative f.', 'B - competitive f.', 'C - combined f.')


% 
% 
% figure
% plot(th(1,:))
% hold on
% plot(thcomp(1, :), 'g')
% plot(thc(1, :), 'b')
% plot(th_cc(1, :), 'r')
% blad(th, thc)
% blad(th, thcomp)
% blad(th, th_cc)

%
% figure;
% %plot(em2, 'r')
% hold on
% plot(Im, 'r')
% plot(Ip, 'g')
%
%
% figure;
% plot(em2, 'r')
% hold on
% plot(ep2, 'g')


%plot(thcomp(1, :), 'b');