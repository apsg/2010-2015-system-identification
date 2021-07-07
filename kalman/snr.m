function r = snr(s, n)
r = 20*log10(rms(s)/rms(n));


function y = rms(x)

y = sqrt(sum(x.^2));