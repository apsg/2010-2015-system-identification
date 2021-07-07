s = RandStream('mcg16807','Seed',0);
RandStream.setDefaultStream(s);

close all
N = 5000;
T = 1:N;
beta = 1;
r = 2;

sv = 0.25;

P = 10;
wyniki =zeros(P,2);
trajektorie = zeros(2,N,P);

h = ones(1,11);

for i=1:P
    
    [fi, y, th] = generuj('B', sv);
    [th1, eo1] = kalman_2s_v2(fi, y, sigmaw(10, sv), sv);
    [th2, eo2] = kalman_2s_v2(fi, y, sigmaw(30, sv), sv);
    [th3, eo3] = kalman_2s_v2(fi, y, sigmaw(90, sv), sv);
    [th4, eo4, ep4] = kalman_2r2s(fi, y, sigmaw2(10, sv), sv);
    [th5, eo5, ep5] = kalman_2r2s(fi, y, sigmaw2(30, sv), sv);
    [th6, eo6, ep6] = kalman_2r2s(fi, y, sigmaw2(90, sv), sv);
    %
    % figure;
    % plot(th(2,:),'b')
    % hold on
    % plot(th1(2,:),'r')
    
    e = zeros(6,N);
    ep = zeros(6,N);
    thf = zeros([size(th), 6]);
    
    e(1, :) = eo1';
    e(2, :) = eo2';
    e(3, :) = eo3';
    e(4, :) = eo4';
    e(5, :) = eo5';
    e(6, :) = eo6';
    %
    %     ep(1, :) = ep1';
    %     ep(2, :) = ep2';
    %     ep(3, :) = ep3';
    %     ep(4, :) = ep4';
    %     ep(5, :) = ep5';
    %     ep(6, :) = ep6';
    
    thf(:,:,1) = th1;
    thf(:,:,2) = th2;
    thf(:,:,3) = th3;
    thf(:,:,4) = th4;
    thf(:,:,5) = th5;
    thf(:,:,6) = th6;
    
   % thc1 = kalmed(thf(:,:,1:3), e(1:3,:));
    thc = kalmed(thf, e);
    
    thcm = ordfilt2(thc, 6, h);
    
    wyniki(i,1) = blad(th, thc);
    wyniki(i,2) = blad(th, thcm);
    trajektorie(:,:,i) = thc;
    
end



disp('1R')
disp(blad(th, th1))
disp(blad(th, th2))
disp(blad(th, th3))
disp('2R')
disp(blad(th, th4))
disp(blad(th, th5))
disp(blad(th, th6))
disp('Medley 3 filtry 1R')
%disp(blad(th, thc1))
disp('Medley 3 x 1R + 3 x 2R')
disp(blad(th, thc))




figure;
plot(th(1, :), 'k'), hold on
plot(th4(1,:), 'c')
plot(th5(1,:), 'm')
plot(th6(1,:), 'y')
% plot(thc(1,:), 'r')

figure;
plot(th(2, :), 'k'), hold on
plot(th1(2,:), 'c')
plot(th2(2,:), 'm')
plot(th3(2,:), 'y')
plot(thc(2,:), 'r')








