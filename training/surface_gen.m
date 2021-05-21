%surface generation
clear;
pts = 50;
interval = 20/pts; %-1 to 1
[x, y] = meshgrid(-10:interval:10, -10:interval:10);

%z = 0.1*(x+10); %2m incline
%z = 0.05*(x+10);  %1m incline

%z = 0.2+ 0.2*sin((4*pi/20)*x); %single sin
%z = 0.1+ 0.1*sin((4*pi/10)*y); %single sinhf

% % %%double sin
%   z = [0.5*sin((4*pi/20)*x)] .* [0.5*sin((4*pi/20)*y)];
%  z = z + 0.25;


% %% disnhf2
%    z = [0.3*sin((4*pi/8)*x)] .* [0.3*sin((4*pi/8)*y)];
%   z = z + 0.1;

%%dsinhf3
   z = [0.2*sin((4*pi/4)*x)] .* [0.3*sin((4*pi/4)*y)];
  z = z + 0.06;


fprintf("max ht %f",max(max(z)));
fprintf("min ht %f",min(min(z)));

figure('Units','inches', ...
'Position',[2 2 10 4], ...
'PaperPositionMode','auto');
surf(x,y,z);
axis([-10 10 -10 10 0 1]);
set(gca,...    
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',11,...
    'FontName','Times')
title('Sinusoidal Terrain II');
xlabel('X');
ylabel('Y');
zlabel('Z');
%print -depsc2 sinhf_terrain.eps
%  %create h-map
 hmap = z;
%  csvwrite('dsinhf3_hmap.txt', hmap);