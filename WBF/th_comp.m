function [thcomp, etapm]=th_comp(fi, y, M, beta)

% sv=0.2;
% [fi, y, th] = generuj('A', sv, 2);

[am11, emo11] = wbf_tracker_m(fi, y, lambda1(10),1);
[ap11, epo11] = wbf_tracker_p(fi, y, lambda1(10),1);

[am12, emo12] = wbf_tracker_m(fi, y, lambda1(30),1);
[ap12, epo12] = wbf_tracker_p(fi, y, lambda1(30),1);

[am13, emo13] = wbf_tracker_m(fi, y, lambda1(90),1);
[ap13, epo13] = wbf_tracker_p(fi, y, lambda1(90),1);


[am21, emo21] = wbf_tracker_m(fi, y, lambda2(10),2);
[ap21, epo21] = wbf_tracker_p(fi, y, lambda2(10),2);

[am22, emo22] = wbf_tracker_m(fi, y, lambda2(30),2);
[ap22, epo22] = wbf_tracker_p(fi, y, lambda2(30),2);

[am23, emo23] = wbf_tracker_m(fi, y, lambda2(90),2);
[ap23, epo23] = wbf_tracker_p(fi, y, lambda2(90),2);


[am31, emo31] = wbf_tracker_m(fi, y, lambda3(10),3);
[ap31, epo31] = wbf_tracker_p(fi, y, lambda3(10),3);

[am32, emo32] = wbf_tracker_m(fi, y, lambda3(30),3);
[ap32, epo32] = wbf_tracker_p(fi, y, lambda3(30),3);

[am33, emo33] = wbf_tracker_m(fi, y, lambda3(90),3);
[ap33, epo33] = wbf_tracker_p(fi, y, lambda3(90),3);
% ---

em11 = abs(emo11).^beta;
em12 = abs(emo12).^beta;
em13 = abs(emo13).^beta;
ep11 = abs(epo11).^beta;
ep12 = abs(epo12).^beta;
ep13 = abs(epo13).^beta;

em21 = abs(emo21).^beta;
em22 = abs(emo22).^beta;
em23 = abs(emo23).^beta;
ep21 = abs(epo21).^beta;
ep22 = abs(epo22).^beta;
ep23 = abs(epo23).^beta;

em31 = abs(emo31).^beta;
em32 = abs(emo32).^beta;
em33 = abs(emo33).^beta;
ep31 = abs(epo31).^beta;
ep32 = abs(epo32).^beta;
ep33 = abs(epo33).^beta;

h = ones(2*M - 1, 1);
h(M+1:end) = 0;

Im11 = filter2(h, em11);
Im12 = filter2(h, em12);
Im13 = filter2(h, em13);

Im21 = filter2(h, em21);
Im22 = filter2(h, em22);
Im23 = filter2(h, em23);

Im31 = filter2(h, em31);
Im32 = filter2(h, em32);
Im33 = filter2(h, em33);

h = ones(2*M - 1, 1);
h(1:M-1) = 0;

Ip11 = filter2(h, ep11);
Ip12 = filter2(h, ep12);
Ip13 = filter2(h, ep13);

Ip21 = filter2(h, ep21);
Ip22 = filter2(h, ep22);
Ip23 = filter2(h, ep23);

Ip31 = filter2(h, ep31);
Ip32 = filter2(h, ep32);
Ip33 = filter2(h, ep33);


mip11 = Ip11.^(-M/beta);
mip12 = Ip12.^(-M/beta);
mip13 = Ip13.^(-M/beta);

mim11 = Im11.^(-M/beta);
mim12 = Im12.^(-M/beta);
mim13 = Im13.^(-M/beta);

mip21 = Ip21.^(-M/beta);
mip22 = Ip22.^(-M/beta);
mip23 = Ip23.^(-M/beta);

mim21 = Im21.^(-M/beta);
mim22 = Im22.^(-M/beta);
mim23 = Im23.^(-M/beta);

mip31 = Ip31.^(-M/beta);
mip32 = Ip32.^(-M/beta);
mip33 = Ip33.^(-M/beta);

mim31 = Im31.^(-M/beta);
mim32 = Im32.^(-M/beta);
mim33 = Im33.^(-M/beta);



misum = sum([...
    mim11 mim12 mim13 mip11 mip12 mip13...
    mim21 mim22 mim23 mip21 mip22 mip23 ...
    mim31 mim32 mim33 mip31 mip32 mip33], 2);

mip11 = (mip11./misum)';
mip12 = (mip12./misum)';
mip13 = (mip13./misum)';
mim11 = (mim11./misum)';
mim12 = (mim12./misum)';
mim13 = (mim13./misum)';

mip21 = (mip21./misum)';
mip22 = (mip22./misum)';
mip23 = (mip23./misum)';
mim21 = (mim21./misum)';
mim22 = (mim22./misum)';
mim23 = (mim23./misum)';

mip31 = (mip31./misum)';
mip32 = (mip32./misum)';
mip33 = (mip33./misum)';
mim31 = (mim31./misum)';
mim32 = (mim32./misum)';
mim33 = (mim33./misum)';


thcomp(1,:) = ...
    mim11.*am11(1,:) + mim12.*am12(1,:) + mim13.*am13(1,:) + ...
    mip11.*ap11(1,:) + mip12.*ap12(1,:) + mip13.*ap13(1,:) + ...
    mim21.*am21(1,:) + mim22.*am22(1,:) + mim23.*am23(1,:) + ...
    mip21.*ap21(1,:) + mip22.*ap22(1,:) + mip23.*ap23(1,:) + ...
    mim31.*am31(1,:) + mim32.*am32(1,:) + mim33.*am33(1,:) + ...
    mip31.*ap31(1,:) + mip32.*ap32(1,:) + mip33.*ap33(1,:);

thcomp(2,:) = ...
    mim11.*am11(2,:) + mim12.*am12(2,:) + mim13.*am13(2,:) + ...
    mip11.*ap11(2,:) + mip12.*ap12(2,:) + mip13.*ap13(2,:) + ...
    mim21.*am21(2,:) + mim22.*am22(2,:) + mim23.*am23(2,:) + ...
    mip21.*ap21(2,:) + mip22.*ap22(2,:) + mip23.*ap23(2,:) + ...
    mim31.*am31(2,:) + mim32.*am32(2,:) + mim33.*am33(2,:) + ...
    mip31.*ap31(2,:) + mip32.*ap32(2,:) + mip33.*ap33(2,:);



epm = ...
    mim11.*emo11' + mim12.*emo12' + mim13.*emo13' + ...
    mip11.*epo11' + mip12.*epo12' + mip13.*epo13' + ...
    mim21.*emo21' + mim22.*emo22' + mim23.*emo23' + ...
    mip21.*epo21' + mip22.*epo22' + mip23.*epo23' + ...
    mim31.*emo31' + mim32.*emo32' + mim33.*emo33' + ...
    mip31.*epo31' + mip32.*epo32' + mip33.*epo33';


epm = abs(epm).^beta;

h = ones(1, M);
etapm = filter2(h, epm);

etapm = etapm.^(-M/beta);
