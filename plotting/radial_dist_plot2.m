clear;
% pts = 50;
pts=50;
interval = 20/pts; %-1 to 1
[x, y] = meshgrid(-10:interval:10, -10:interval:10);

z = [0.5*sin((4*pi/20)*x)] .* [0.5*sin((4*pi/20)*y)];
z = z + 0.25;
  
% traj = csvread('dsinhf3_curve_left2.csv');

% init = traj(1,:);
init = [1.2,1.2];

  fprintf("max ht %f",max(max(z)));
fprintf("min ht %f",min(min(z)));

figure('Units','inches', ...
'Position',[2 2 12 5], ...
'PaperPositionMode','auto');
% surf(x,y,z);

subplot(1,2,1);
contourf(x,y,z,10);

% axis([-10 10 -10 10 0 1]);
axis([init(1)-1.6 init(1)+1.6 init(2)-1.6 init(2)+1.6]);
set(gca,...    
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',11,...
    'FontName','Times')
title('Terrain Changes in Uneven Terrain');
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');

hold on;
scatter(init(1),init(2),'k','filled');
hold on;

viscircles(init(1:2), 0.25,'LineWidth',1);
viscircles(init(1:2), 0.5,'LineWidth',1);
viscircles(init(1:2), 0.75,'LineWidth',1);
viscircles(init(1:2), 1,'LineWidth',1);
viscircles(init(1:2), 1.25,'LineWidth',1);
% r=0.1;
% th = [0:pi/50:2*pi];
% xc = init(1) + r*cos(th);
% yc = init(2) + r*sin(th);
% zc= repelem(0.15, size(xc,2));
% plot([xc,yc,zc]);

subplot(1,2,2);
% xarr = [0.1, 0.25, 0.5, 0.75, 1.0];
xarr = categorical({'0.25','0.5','0.75','1.0','1.25'});
yarr = [1.53, 1.6, 1.52 ,1.55 ,1.7];
bar(xarr,yarr)
title('Tracking Error for selected Radial Distance');
xlabel('Radial Distance Selected to get Height Difference');
ylabel('RMS Tracking Error (cm)');
ylim([1.25 2.0]);