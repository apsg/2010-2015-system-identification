function [th, spr]=th_comp(fi, y, sv)

K=3;

[am1, emo1] = tracker_m(fi, y, sigmaw(10, sv), sv);
[ap1, epo1] = tracker_p(fi, y, sigmaw(10, sv), sv);

[am2, emo2] = tracker_m(fi, y, sigmaw(30, sv), sv);
[ap2, epo2] = tracker_p(fi, y, sigmaw(30, sv), sv);

[am3, emo3] = tracker_m(fi, y, sigmaw(90, sv), sv);
[ap3, epo3] = tracker_p(fi, y, sigmaw(90, sv), sv);

em1 = emo1.^2;
em2 = emo2.^2;
em3 = emo3.^2;
ep1 = epo1.^2;
ep2 = epo2.^2;
ep3 = epo3.^2;

M = 21;

h = ones(2*M - 1, 1);
h(M+1:end) = 0;

Im1 = filter2(h, em1);
Im2 = filter2(h, em2);
Im3 = filter2(h, em3);

h = ones(2*M - 1, 1);
h(1:M-1) = 0;

Ip1 = filter2(h, ep1);
Ip2 = filter2(h, ep2);
Ip3 = filter2(h, ep3);

mip1 = Ip1.^(-M/2);
mip2 = Ip2.^(-M/2);
mip3 = Ip3.^(-M/2);

mim1 = Im1.^(-M/2);
mim2 = Im2.^(-M/2);
mim3 = Im3.^(-M/2);

misum = sum([mim1 mim2 mim3 mip1 mip2 mip3], 2);

mip1 = (mip1./misum)';
mip2 = (mip2./misum)';
mip3 = (mip3./misum)';
mim1 = (mim1./misum)';
mim2 = (mim2./misum)';
mim3 = (mim3./misum)';

spr = mip1 + mip2 + mip3 + mim1 + mim2 + mim3;

th(1,:) = ...
    mim1.*am1(1,:) + mim2.*am2(1,:) + mim3.*am3(1,:) + ...
    mip1.*ap1(1,:) + mip2.*ap2(1,:) + mip3.*ap3(1,:);

th(2,:) = ...
    mim1.*am1(2,:) + mim2.*am2(2,:) + mim3.*am3(2,:) + ...
    mip1.*ap1(2,:) + mip2.*ap2(2,:) + mip3.*ap3(2,:);



% 
% M = 11;
% h = ones(1, 2*M - 1);
% h(M+1:end) = 0;
% 
% em = [emo1'; emo2'; emo3'];
% esumm = filter2(h, abs(em).^2);
% 
% psi = (-M/2) * log(esumm);
% psimax = max(psi, [],1);
% 
% chi = zeros(size(psi));
% for i=1:K
%     chi(i,:) = psi(i,:) - psimax;
% end
% chi = exp(chi);
% chisums = sum(chi,1);
% mkm = zeros(size(em));
% for i=1:K
%     mkm(i,:) = chi(i,:)./ chisums;
% end
% 
% M = 11;
% h = ones(1, 2*M - 1);
% h(1:M) = 0;
% 
% ep = [epo1'; epo2'; epo3'];
% esump = filter2(h, abs(ep).^2);
% 
% psi = (-M/2) * log(esump);
% psimax = max(psi, [],1);
% 
% chi = zeros(size(psi));
% for i=1:K
%     chi(i,:) = psi(i,:) - psimax;
% end
% chi = exp(chi);
% chisums = sum(chi,1);
% mkp = zeros(size(ep));
% for i=1:K
%     mkp(i,:) = chi(i,:)./ chisums;
% end
% 
% mkm = mkm/2;
% mkp = mkp/2;
% 
% th(1,:) = ...
%     mkm(1,:).*am1(1,:) + mkm(2,:).*am2(1,:) + mkm(3,:).*am3(1,:) + ...
%     mkp(1,:).*ap1(1,:) + mkp(2,:).*ap2(1,:) + mkp(3,:).*ap3(1,:) ;
% 
% 
% th(2,:) = ...
%     mkm(1,:).*am1(2,:) + mkm(2,:).*am2(2,:) + mkm(3,:).*am3(2,:) + ...
%     mkp(1,:).*ap1(2,:) + mkp(2,:).*ap2(2,:) + mkp(3,:).*ap3(2,:) ;

