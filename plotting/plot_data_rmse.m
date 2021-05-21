clear all;
%fig = openfig('errors.fig');
fig = gcf;

a = get(gca,'Children');
axObjs = fig.Children;
dataObjs = axObjs.Children;
xdata = get(a, 'XData');
ydata = get(a, 'YData');

figure('Units','inches', ...
'Position',[2 2 5 4], ...
'PaperPositionMode','auto');

plot(xdata,ydata,'-r');

set(gca,...    
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',11,...
    'FontName','Times')
title('Trajectory Error : Rough Terrain, Curve');
xlabel('Time');
ylabel('Perpendicular Error (m)');
%legend('x','y','z','\alpha','\beta','\gamma');
%axis([0 45 0 0.03]);
print -depsc2 rmse_dsinhf3_curve.eps