close all
N = 5000;
T = 1:N;
beta = 1;
r = 2;

wyniki = zeros(10, 7);
L = zeros(10,1);
for id = 1:1
    sv = id*0.2;
    L(id) = ( sv);
    [fi, y, th] = generuj('A', sv);
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
    
    thc1 = kalmed(thf(:,:,1:3), e(1:3,:));
    thc = kalmed(thf, e);
    thcp1 = kalmed(thf(:,:,1:3), ep(1:3,:));
    thcp = kalmed(thf, ep);
    
    wyniki(id,1) = blad(th, th1);
    wyniki(id,2) = blad(th, th2);
    wyniki(id,3) = blad(th, th3);
    wyniki(id,4) = blad(th, th4);
    wyniki(id,5) = blad(th, th5);
    wyniki(id,6) = blad(th, th6);
    
    wyniki(id,7) = blad(th, thc1);
end
% 
figure;
plot(L, wyniki(:,1:3), 'k');
hold on 
plot(L, wyniki(:,4:6), 'b');
plot(L, wyniki(:,7),'r');
disp('1R')
disp(blad(th, th1))
disp(blad(th, th2))
disp(blad(th, th3))
disp('2R')
disp(blad(th, th4))
disp(blad(th, th5))
disp(blad(th, th6))
disp('Medley 3 filtry 1R')
disp(blad(th, thc1))
disp('Medley 3 x 1R + 3 x 2R')
disp(blad(th, thc))
% disp('Medley 3 filtry 1R - wypelnienie')
% disp(blad(th, thcp1))
% disp('Medley 3 x 1R + 3 x 2R - wypelnienie')
% disp(blad(th, thcp))

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
