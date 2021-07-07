% 3x CKF + 3x CMed
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


for i=1:P
    
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
    
   % thc1 = kalmed(thf(:,:,1:3), e(1:3,:));
    thc = kalmed(thf, e);
    
    [thcm1 em1] = med(thc, 11);
    [thcm2 em2] = med(thc, 33);
    [thcm3 em3] = med(thc, 99);
  
    [thcm mkm] = C1med(thcm1, thcm2, thcm3, em1, em2, em3);
    
    wyniki(i,1) = blad(th, thcm1);
    wyniki(i,2) = blad(th, thcm2);
    wyniki(i,3) = blad(th, thcm3);
    
    wyniki(i,4) = blad(th, thc);
    wyniki(i,5) = blad(th, thcm);
    
end
% 
% disp('Med(11), med(33), med(99)');
% disp(blad(th, thcm1))
% disp(blad(th, thcm2))
% disp(blad(th, thcm3))
% disp('CKF, CKF+CMed')
disp(wyniki);



