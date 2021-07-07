close all

sv = 0.1;
[fi, y, th] = generuj('B', sv);

sw = sigmaw(100,sv);

P = [];
W = [];
for p = 0.001:0.005:0.02
    P = [P, p];
    
    th1 = kalman_2s(fi, y, sw, sv);
    th2 = kalman_2r2s(fi, y, p*sw, sv);
    
    W = [W, blad(th1, th2)];
end
plot(P,W), set(gca, 'ylim', [0,2])