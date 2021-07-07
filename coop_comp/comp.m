function [thcomp, etapm, thcomp2, etapm2, am2, ap2] = comp(fi, y, sv, M, beta)


K=3;

[am1, emo1] = tracker_m(fi, y, sigmaw(10, sv), sv);
[ap1, epo1] = tracker_p(fi, y, sigmaw(10, sv), sv);

[am2, emo2] = tracker_m(fi, y, sigmaw(30, sv), sv);
[ap2, epo2] = tracker_p(fi, y, sigmaw(30, sv), sv);

[am3, emo3] = tracker_m(fi, y, sigmaw(90, sv), sv);
[ap3, epo3] = tracker_p(fi, y, sigmaw(90, sv), sv);

% ---

[am12, emo12] = tracker_m2(fi, y, sigmaw2(10, sv), sv);
[ap12, epo12] = tracker_p2(fi, y, sigmaw2(10, sv), sv);

[am22, emo22] = tracker_m2(fi, y, sigmaw2(30, sv), sv);
[ap22, epo22] = tracker_p2(fi, y, sigmaw2(30, sv), sv);

[am32, emo32] = tracker_m2(fi, y, sigmaw2(90, sv), sv);
[ap32, epo32] = tracker_p2(fi, y, sigmaw2(90, sv), sv);

% ---

em1 = abs(emo1).^beta;
em2 = abs(emo2).^beta;
em3 = abs(emo3).^beta;
ep1 = abs(epo1).^beta;
ep2 = abs(epo2).^beta;
ep3 = abs(epo3).^beta;

em12 = abs(emo12).^beta;
em22 = abs(emo22).^beta;
em32 = abs(emo32).^beta;
ep12 = abs(epo12).^beta;
ep22 = abs(epo22).^beta;
ep32 = abs(epo32).^beta;


M = 21;

h = ones(2*M - 1, 1);
h(M+1:end) = 0;

Im1 = filter2(h, em1);
Im2 = filter2(h, em2);
Im3 = filter2(h, em3);

Im12 = filter2(h, em12);
Im22 = filter2(h, em22);
Im32 = filter2(h, em32);


h = ones(2*M - 1, 1);
h(1:M-1) = 0;

Ip1 = filter2(h, ep1);
Ip2 = filter2(h, ep2);
Ip3 = filter2(h, ep3);

Ip12 = filter2(h, ep12);
Ip22 = filter2(h, ep22);
Ip32 = filter2(h, ep32);

mip1 = Ip1.^(-M/beta);
mip2 = Ip2.^(-M/beta);
mip3 = Ip3.^(-M/beta);

mim1 = Im1.^(-M/beta);
mim2 = Im2.^(-M/beta);
mim3 = Im3.^(-M/beta);


mip12 = Ip12.^(-M/beta);
mip22 = Ip22.^(-M/beta);
mip32 = Ip32.^(-M/beta);

mim12 = Im12.^(-M/beta);
mim22 = Im22.^(-M/beta);
mim32 = Im32.^(-M/beta);

misum = sum([mim1 mim2 mim3 mip1 mip2 mip3], 2);
misum2 = sum([mim1 mim2 mim3 mip1 mip2 mip3 mim12 mim22 mim32 mip12 mip22 mip32], 2);

mip112 = (mip1./misum2)';
mip222 = (mip2./misum2)';
mip332 = (mip3./misum2)';
mim112 = (mim1./misum2)';
mim222 = (mim2./misum2)';
mim332 = (mim3./misum2)';

mip12 = (mip12./misum2)';
mip22 = (mip22./misum2)';
mip32 = (mip32./misum2)';
mim12 = (mim12./misum2)';
mim22 = (mim22./misum2)';
mim32 = (mim32./misum2)';

mip1 = (mip1./misum)';
mip2 = (mip2./misum)';
mip3 = (mip3./misum)';
mim1 = (mim1./misum)';
mim2 = (mim2./misum)';
mim3 = (mim3./misum)';



thcomp(1,:) = ...
    mim1.*am1(1,:) + mim2.*am2(1,:) + mim3.*am3(1,:) + ...
    mip1.*ap1(1,:) + mip2.*ap2(1,:) + mip3.*ap3(1,:);

thcomp(2,:) = ...
    mim1.*am1(2,:) + mim2.*am2(2,:) + mim3.*am3(2,:) + ...
    mip1.*ap1(2,:) + mip2.*ap2(2,:) + mip3.*ap3(2,:);

thcomp2(1, :) = ...
    mim112.*am1(1,:) + mim222.*am2(1,:) + mim332.*am3(1,:) + ...
    mip112.*ap1(1,:) + mip222.*ap2(1,:) + mip332.*ap3(1,:) + ...
    mim12.*am12(1,:) + mim22.*am22(1,:) + mim32.*am32(1,:) + ...
    mip12.*ap12(1,:) + mip22.*ap22(1,:) + mip32.*ap32(1,:);

thcomp2(2, :) = ...
    mim112.*am1(2,:) + mim222.*am2(2,:) + mim332.*am3(2,:) + ...
    mip112.*ap1(2,:) + mip222.*ap2(2,:) + mip332.*ap3(2,:) + ...
    mim12.*am12(2,:) + mim22.*am22(2,:) + mim32.*am32(2,:) + ...
    mip12.*ap12(2,:) + mip22.*ap22(2,:) + mip32.*ap32(2,:);

epm = ...
    mim1.*emo1' + mim2.*emo2' + mim3.*emo3' + ...
    mip1.*epo1' + mip2.*epo2' + mip3.*epo3';

epm2 = ...
    mim112.*emo1' + mim222.*emo2' + mim332.*emo3' + ...
    mip112.*epo1' + mip222.*epo2' + mip332.*epo3' + ...
    mim12.*emo12' + mim22.*emo22' + mim32.*emo32' + ...
    mip12.*epo12' + mip22.*epo22' + mip32.*epo32' ;
    

epm = abs(epm).^beta;
epm2 = abs(epm2).^beta;

h = ones(1, M);
etapm = filter2(h, epm);
etapm2 = filter2(h, epm2);

etapm = etapm.^(-M/beta);
etapm2 = etapm2.^(-M/beta);



