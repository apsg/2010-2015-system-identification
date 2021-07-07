clc
clear all
% load 'A'
% 
% 
% figure;
% subplot(3,1,1)
% p = plot(th(1,:), 'k--'), set(gca, 'XLim', [1900, 2300])
% set(gca, 'XTickLabel', [])
% set(gca, 'FontSize', 18)
% hold on
% plot(thc(1,:), 'k-')
% set(gca, 'YTick', [-0.5, -0.3, -0.1, 0.1])
% subplot(3,1,2), 
% p=plot(th(1,:), 'k--'), set(gca, 'XLim', [1900, 2300])
% set(gca, 'XTickLabel', [])
% set(gca, 'FontSize', 18)
% hold on
% plot(thcomp(1,:), 'k-')
% set(gca, 'YTick', [-0.5, -0.3, -0.1, 0.1])
% subplot(3,1,3), 
% p = plot(th(1,:), 'k--'), set(gca, 'XLim', [1900, 2300])
% set(gca, 'FontSize', 18)
% hold on
% plot(th_cc(1,:), 'k-')
% set(gca, 'YTick', [-0.5, -0.3, -0.1, 0.1])
% 


load 'C'


figure;
subplot(3,1,1), plot(th(1,:), 'k--'), set(gca, 'XLim', [3100, 3700])
set(gca, 'YLim', [-0.05, 0.4])
 set(gca, 'XTickLabel', [])
set(gca, 'FontSize', 18)
hold on
plot(thc(1,:), 'k-')
subplot(3,1,2), plot(th(1,:), 'k--'), set(gca, 'XLim', [3100, 3700])
set(gca, 'YLim', [-0.05, 0.4])
 set(gca, 'XTickLabel', [])
set(gca, 'FontSize', 18)
hold on
plot(thcomp(1,:), 'k-')
subplot(3,1,3), plot(th(1,:), 'k--'), set(gca, 'XLim', [3100, 3700])
set(gca, 'YLim', [-0.05, 0.4])
set(gca, 'FontSize', 18)
hold on
plot(th_cc(1,:), 'k-')