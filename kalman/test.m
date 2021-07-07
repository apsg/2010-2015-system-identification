close all
clc
[fi, y, th, sv] = generuj('A', 0.2);

th1 = kalman_2r2s(fi, y, (0.5/40)*sigmaw(40, 0.3*0.2), 0.3*0.2);
% 
% [th2, eo1] = kalman_2s_v2(fi, y, sigmaw(50,0.3*0.2),0.3*0.2);
% [th3, eo2, ep2] = kalman_2s_BF(fi, y, sigmaw(50,0.3*0.2), 0.3*0.2);
% disp('blad th');
% disp(blad(th2, th3));
% disp('blad eo')
% disp(sum(abs(eo1(100:end-100) - eo2(100:end-100))));
% 
% figure;
% p = plot(th', 'k');
% set(p, 'linewidth',2);
% hold on
% plot(th2', 'b');
% plot(th3', 'g');
% 
% figure
% plot(eo2), hold on
% plot(ep2, 'g')
