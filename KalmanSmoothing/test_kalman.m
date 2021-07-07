N = 5000; % number of samples
T = 1:N;
beta = 2; % noise type. Use 1 for Laplacian noise, 2 for gaussian noise (or any other value)
%r = 2;

% Select noise standard deviation (STD)
sv = 0.2;

% generate the input variables - regression vector, system output (noised)
% and vector of original parameters
[fi, y, th] = generuj('A', sv);

% 3 Kalman smoothers based on 1st order random walk model (different
% memories)
[th1, eo1] = kalman_2s_v2(fi, y, sigmaw(10, sv), sv);
[th2, eo2] = kalman_2s_v2(fi, y, sigmaw(30, sv), sv);
[th3, eo3] = kalman_2s_v2(fi, y, sigmaw(90, sv), sv);

% 3 Kalman smoothers based on 2nd order random walk model (different
% memories)
[th4, eo4, ep4] = kalman_2r2s(fi, y, sigmaw2(10, sv), sv);
[th5, eo5, ep5] = kalman_2r2s(fi, y, sigmaw2(30, sv), sv);
[th6, eo6, ep6] = kalman_2r2s(fi, y, sigmaw2(90, sv), sv);

e = zeros(6,N);
thf = zeros([size(th), 6]);

% Store corresponding matching errors obtained using holey smoothers in
% matrix e
e(1, :) = eo1';
e(2, :) = eo2';
e(3, :) = eo3';
e(4, :) = eo4';
e(5, :) = eo5';
e(6, :) = eo6';

% store the output trajectories obtained by different smoothers in one
% matrix - thf
thf(:,:,1) = th1;
thf(:,:,2) = th2;
thf(:,:,3) = th3;
thf(:,:,4) = th4;
thf(:,:,5) = th5;
thf(:,:,6) = th6;

% Compute the results of cooperative smoother using only the results of
% first 3 smoothers (only 1st order IRW model)
thc1 = kalmed(thf(:,:,1:3), e(1:3,:));
% Compute the results of cooperative smoother using all the results (1st
% and 2nd order IRW model)
thc = kalmed(thf, e);


% display the results and plot the 

disp('1st order IRW models')
disp(blad(th, th1))
disp(blad(th, th2))
disp(blad(th, th3))
disp('2nd order IRW models')
disp(blad(th, th4))
disp(blad(th, th5))
disp(blad(th, th6))
disp('Medley filter - 3x1st order IRW')
disp(blad(th, thc1))
disp('Medley filter - 3 x 1st + 3 x 2nd order IRW')
disp(blad(th, thc))


figure;
plot(th(1, :), 'k'), hold on
plot(th4(1,:), 'c')
plot(th5(1,:), 'm')
plot(th6(1,:), 'y')
legend('Original trajectory', '2nd order IRW Kalman smoother 1','2nd order IRW Kalman smoother 2','2nd order IRW Kalman smoother 3')
% plot(thc(1,:), 'r')

figure;
plot(th(2, :), 'k'), hold on
plot(th1(2,:), 'c')
plot(th2(2,:), 'm')
plot(th3(2,:), 'y')
plot(thc(2,:), 'r')
legend('Original trajectory', '1st order IRW Kalman smoother 1','1st order IRW Kalman smoother 2','1st order IRW Kalman smoother 3', 'Medley smoother (6 basic filters)')
