% test EWLS vs Kalman



[fi, y, th, sv] = generuj('A', 0.1);


[th1, eo1] = EWLS(fi, y, (6));
[th2, eo2] = EWLS(fi, y, (18));
[th3, eo3] = EWLS(fi, y, (52));


thw = zeros([size(th),3]);
thw(:,:,1) = th1;
thw(:,:,2) = th2;
thw(:,:,3) = th3;

eo = [eo1';eo2';eo3'];

thc1 = kalmed(thw, eo);
blad(th, thc1)


[th1, eo1, ep1] = kalman_2r2s(fi, y,  sigmaw2(52, sv), sv);
[th2, eo2, ep2] = kalman_2r2s(fi, y, sigmaw2(18, sv), sv);
[th3, eo3, ep3] = kalman_2r2s(fi, y, sigmaw2(6, sv), sv);

[th4, eo4, ep1] = kalman_2s(fi, y,  sigmaw(52, sv), sv);
[th5, eo5, ep2] = kalman_2s(fi, y, sigmaw(18, sv), sv);
[th6, eo6, ep3] = kalman_2s(fi, y, sigmaw(6, sv), sv);

thw = zeros([size(th),6]);
thw(:,:,1) = th1;
thw(:,:,2) = th2;
thw(:,:,3) = th3;
thw(:,:,4) = th4;
thw(:,:,5) = th5;
thw(:,:,6) = th6;

eo = [eo1';eo2';eo3';eo4';eo5';eo6'];
thc2 = kalmed(thw, eo);
blad(th, thc2)

plot(th', 'k');
hold on
plot(thc1', 'b');

plot(thc2', 'r')
