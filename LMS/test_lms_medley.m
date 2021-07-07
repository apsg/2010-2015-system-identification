% test LMS medley

close all
[fi, y, th] = generuj('A', 0.2, 2);
N = length(y);

[th1, eo1] = LMS(fi, y, mi(15, 1));
[th2, eo2] = LMS(fi, y, mi(30, 1));
[th3, eo3] = LMS(fi, y, mi(60, 1));

TH = zeros([size(th), 3]);
TH(:,:,1) = th1;
TH(:,:,2) = th2;
TH(:,:,3) = th3;

e = [eo1';eo2';eo3'];

thc = C1(th3, th2, th1, eo3, eo2, eo1, 2);
thc2 = medley(TH, e, 2);


disp('th1')
disp(blad(th, th1));
disp('th2')
disp(blad(th, th2));
disp('th3')
disp(blad(th, th3));
disp('thc')
disp(blad(th, thc));
disp(blad(th, thc2));


figure;
plot(th(1,:), 'k'), hold on
plot(th1(1,:), 'b')
plot(thc(1,:), 'r')
plot(th3(1, :), 'y')