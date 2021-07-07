function [e ] = blad(th, th_est)


l = l2norm(th(:, 101:end-100) - th_est(:, 101:end-100));
e = sum(l.^2,2);


function y = l2norm(x)
y = sqrt(x(1,:).^2 + x(2,:).^2);
