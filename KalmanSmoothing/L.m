function noised = L(img, mi, std)
n = rand(size(img));
ind = (n <= 0.5);
noise = zeros(size(img));
noise(ind) = log( 2* n(ind));
noise(~ind) = -log(2 - 2*n(~ind)); % tmp(~ind);

noise = (std/sqrt(2)) *noise;
noise = noise + mi;
noised = noise;