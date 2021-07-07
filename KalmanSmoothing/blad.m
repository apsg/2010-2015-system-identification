% Compute the modelling error - the difference between the original parameters 
% trajectories and the estimated trajectories
% It clippes first and last 100 samples (it takes into account only the
% steady-state values)
function [e e2] = blad(th, th_est)


l = l2norm(th(:, 101:end-100) - th_est(:, 101:end-100));
e = sum(l.^2,2);

h = ones(1, 31);
e2 = filter2(h, l.^2);

function y = l2norm(x)
y = sqrt(x(1,:).^2 + x(2,:).^2);
