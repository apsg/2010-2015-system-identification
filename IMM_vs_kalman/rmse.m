function x = rmse(s1,s2)

x = (l2norm(s1-s2));

function y = l2norm(x)
y = sqrt(x(1,5:end-5).^2 + x(2,5:end-5).^2);