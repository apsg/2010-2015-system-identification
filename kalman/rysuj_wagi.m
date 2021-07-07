function rysuj_wagi(mk)
figure;
if(size(mk, 1) == 3)
    subplot(3,1,1), plot(mk(1,:)), set(gca, 'YLim', [-0.1, 1.1])
    subplot(3,1,2), plot(mk(2,:)), set(gca, 'YLim', [-0.1, 1.1])
    subplot(3,1,3), plot(mk(3,:)), set(gca, 'YLim', [-0.1, 1.1])
elseif(size(mk, 1) == 6)
    
    subplot(6,1,1), plot(mk(1,:)), set(gca, 'YLim', [-0.1, 1.1])
    subplot(6,1,2), plot(mk(2,:)), set(gca, 'YLim', [-0.1, 1.1])
    subplot(6,1,3), plot(mk(3,:)), set(gca, 'YLim', [-0.1, 1.1])
    subplot(6,1,4), plot(mk(4,:)), set(gca, 'YLim', [-0.1, 1.1])
    subplot(6,1,5), plot(mk(5,:)), set(gca, 'YLim', [-0.1, 1.1])
    subplot(6,1,6), plot(mk(6,:)), set(gca, 'YLim', [-0.1, 1.1])
end