
sv=0.2;
[fi, y, th] = generuj('A', sv, 2);

N = length(y);

lam = 0.95;
beta=2;

[ths, eo] = wbf_smoother(fi, y, lam);

[thm, em] = wbf_tracker_m(fi, y, lam);
[thp, ep] = wbf_tracker_p(fi, y, lam);


[thc, spr] = th_comp(fi, y, 21, 2);


[th1, eo1] = wbf_smoother(fi, y, lambda2(25));
[th2, eo2] = wbf_smoother(fi, y, lambda2(15));
[th3, eo3] = wbf_smoother(fi, y, lambda2(5));

e = zeros(3,N);
thf = zeros([size(th), 3]);

e(1, :) = eo1';
e(2, :) = eo2';
e(3, :) = eo3';

thf(:,:,1) = th1;
thf(:,:,2) = th2;
thf(:,:,3) = th3;

[thc1, mk1] = med(thf, e, beta);

