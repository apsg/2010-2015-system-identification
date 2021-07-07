s1 = 0;
s2 = 0;
t = 1800;
lam = lambda(20);

for i=1:2000
s1 = s1 + lam^abs(t-i);
s2 = s2 + lam^(2 * abs(t - i));
end

s1^2 / s2

(1+lam)^3 / ((1-lam)*(1+lam^2))