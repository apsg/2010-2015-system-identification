% Computes the sigma_w value for given sigma_v (noise STD) and l (equivallent window width)
% for the 1st order IRW Kalman smoothers
function s = sigmaw(l, sigmav)
s = 4*sigmav / l;