
sv = 0.2

[fi, y, th, sv, sn] = generuj('A', sv);

[th1, eo1] = kalman_2s_v2(fi, y, sigmaw(25, sv), sv);
[th2, eo2] = kalman_2s_BF(fi, y, sigmaw(25, sv), sv);
[th3, eo3] = kalman_770(fi, y, sigmaw(25, sv), sv);


disp(blad(th1, th2));
disp(blad(th1, th2));

figure;
plot(th(1,:), 'k')
hold on
plot(th1(1,:), 'r')
plot(th2(1,:), 'g')
plot(th3(1,:), 'b')
