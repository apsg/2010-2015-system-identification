% wartosci ksi
sv = 0.1;
for K = [90, 30, 10 ] 
    disp((sigmaw(K, sv)/sv)^2);
    disp((sigmaw2(K, sv)/sv)^2);
end