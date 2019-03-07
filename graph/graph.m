close all;
clear all;
clc;

theta = 0:pi/40:2*pi;
y1 = cos(theta);
y2 = sin(theta);
subplot(1,2,1);plot(theta,y1,'o--g',theta,y2,'p:r');
legend('cos(x)','sin(x)');
xlabel('x = 0 ~ 2*pi');
ylabel('y = -1 ~ +1');
title('(未調整)cos(x) and sin(x) comparison');

subplot(1,2,2);plot(theta,y1,'o--g',theta,y2,'p:r');
legend('cos(x)','sin(x)');
xlabel('x = 0 ~ 2*pi');
ylabel('y = -1 ~ +1');
title('(調整)cos(x) and sin(x) comparison');
set(gca,'Fontsize',12);
set(gca, 'XTick', 0:pi/2:2*pi);
set(gca,'FontName','symbol');
set(gca,'XTickLabel',{'0','pi/2','pi','3pi/2','2pi'})
xlim([1,2*pi])

saveas(gcf,'cos(x)&sin(x)','png');
