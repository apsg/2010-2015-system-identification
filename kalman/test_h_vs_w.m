% test wydrążony vs wypełniony
close all

sv = 0.1;

[fi, y, th] = generuj('A', sv);
% 
% [th1, eo1, ep1] = kalman_2r2s(fi, y, 0.011* sigmaw(90, sv), sv);
% [th2, eo2, ep2] = kalman_2r2s(fi, y, 0.03*sigmaw(30, sv), sv);
% [th3, eo3, ep3] = kalman_2r2s(fi, y, 0.1*sigmaw(10, sv), sv);

[th1, eo1, ep1] = kalman_2s_v2(fi, y,  sigmaw(90, sv), sv);
[th2, eo2, ep2] = kalman_2s_v2(fi, y, sigmaw(30, sv), sv);
[th3, eo3, ep3] = kalman_2s_v2(fi, y, sigmaw(10, sv), sv);

thw = zeros([size(th),3]);
thw(:,:,1) = th1;
thw(:,:,2) = th2;
thw(:,:,3) = th3;

eo = [eo1';eo2';eo3'];
ep = [ep1';ep2';ep3'];

thc1 = kalmed(thw, eo);
thc2 = kalmed(thw, ep);

disp('Wydrazony')
disp(blad(th, thc1))
disp('wypelniony')
disp(blad(th, thc2))


plot(th(1, :), 'k')
hold on
plot(thc1(1, :), 'r')
plot(thc2(1, :), 'g')
