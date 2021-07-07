% Computes the sigma_w value for given sigma_v (noise STD) and l (equivallent window width)
% for the 2nd order IRW Kalman smoothers
function sw = sigmaw2(l, sigmav)
sw = 2*sigmav / (l^2);