clear;

%% plot surface and traj
% load('trc_data_sync_sin_4x50','Xtr1','tar1','xyzphi_store');
% pts = 50;
% interval = 20/pts; %-1 to 1
% [x, y] = meshgrid(-10:interval:10, -10:interval:10);
% z = 0.2+ 0.2*sin((4*pi/20)*x); %single sin
% figure('Units','inches', ...
% 'Position',[2 2 10 4], ...
% 'PaperPositionMode','auto');
% 
% surf(x,y,z);
% axis([-10 10 -10 10 0 1.5]);
% hold on;
% plot3(xyzphi_store(:,1),xyzphi_store(:,2),xyzphi_store(:,3),'.k');
% set(gca,...    
%     'FontUnits','points',...
%     'FontWeight','normal',...
%     'FontSize',11,...
%     'FontName','Times')
% title('Training Trajectories on a Sinusoidal Surface ');
% xlabel('X(m)');
% ylabel('Y(m)');
% zlabel('Z(m)');
% 


%% RMSE vs H
% H = [2 4 6 8 10 14 18 22];
% error = [ 0.0596 0.056  0.0410 0.044 0.0325 0.0365 0.0380 0.0395];
% 
% plot(H,error,'-ok');
% axis([1 23 0.0 0.07]);
% title('Perpendicular error vs Horizon (Random Shooting)');
% ylabel('Perpendicular error (m)');
% xlabel('Horizon');
% 
 %% RMSE vs dt
% dt= [ 2,4,6,8,10];
% traj_rmse = [0.049 0.028 0.032 0.029 0.045];
% tr_error = [0.2 0.4 0.5 0.6 0.6]; %rmse not normalised
% % plot(dt,traj_rmse,'-ok',dt,tr_error,'-ob');
% % legend('trajectory error','training error');
% plot(dt,traj_rmse,'-ok');
% title('Trajectory Error vs dt selected');
% xlabel('dt (x50ms)')
% ylabel('RMS Error (m)');
% axis([1 11 0 0.12]);
% 
%% Training error vs dt
% dt= [ 2,4,6,8,10];
% traj_rmse = [0.049 0.028 0.032 0.029 0.045];
% tr_error = [0.2 0.4 0.5 0.6 0.6]; %rmse not normalised
% 
% figure('Units','inches', ...
% 'Position',[2 2 5 4], ...
% 'PaperPositionMode','auto');
% 
% plot(dt,tr_error,'-ob');
% set(gca,...    
%     'FontUnits','points',...
%     'FontWeight','normal',...
%     'FontSize',11,...
%     'FontName','Times')
% 
% 
% title({'Training Error vs $\Delta t$ Selected'},'interpreter','latex');
% xlabel({'$\Delta t$ (x50ms)'},'interpreter','latex');
% ylabel('Training RMS Error');
% axis([1 11 0 1]);
% %print -depsc2 trainerror_vs_dt.eps

%% CEM Plots

% runs = [1 2 3];
% rmse_s = [1.6 0.8 0.6];
% rmse_c = [1.9 1.8 1.4];
% 
% plot(runs,rmse_s,'-ok',runs,rmse_c,'-ob');
% title(' Cross Entropy Method Flat Ground');
% xlabel('Simulations')
% ylabel('RMS Error(cm)');
% legend('Straight Line Traj','Curved Traj');
% axis([0.5 3.5  0 2]);

%% Training data vs accuracy
% data = [6000 12000 18000 24000];
% rmse = [1.93 1.4 1.3 1.3];
% figure('Units','inches', ...
% 'Position',[2 2 5 4], ...
% 'PaperPositionMode','auto');
% 
% plot(data,rmse,'-ob');
% set(gca,...    
%     'FontUnits','points',...
%     'FontWeight','normal',...
%     'FontSize',11,...
%     'FontName','Times')
% 
% 
% title(' Trajectory Error vs Training Data');
% xlabel('Training Data');
% ylabel('Traj Error (cm)');
% 
% axis([3000 26000  1 2]);
% 
% print -depsc2 traindata_vs_rmse.eps

%% H,K Tuning
% 
% H = [2 4 8 12];
% k200 = [ 3.16 2.7 6.2 9.2];
% k400 = [2.9 1.8 5.4 10.4];
% k800 = [3.3 2.3 5.4 6];
% k1200 = [2.2 2.3 4.0  4.5];
% 
% plot(H,k200,'-ok',H,k400,'-ob',H,k800,'-og',H,k1200,'-or');
% title('Effect of H and K on Trajectory Error');
% xlabel('Horizon H')
% ylabel('Traj Error (cm)');
% legend('K=200','K=400','K=800','K=1200');
% axis([1 14  0 12]);

%% reward cem and random
% load('cem_rewards','curr_reward','std_store');
% cem_rew = curr_reward;
% cem_std = std_store;
% load('cem_rewards_conv','curr_reward','std_store');
% cem_rew_c = curr_reward;
% cem_std_c = std_store;
% load('rand_rewards','curr_reward');
% 
% figure('Units','inches', ...
% 'Position',[2 2 5 4], ...
% 'PaperPositionMode','auto');
% 
% % plot([1:49],cem_rew(1:49),'-b',[1:49],curr_reward(1:49),'--b','LineWidth',1);
% % set(gca,...    
% %     'FontUnits','points',...
% %     'FontWeight','normal',...
% %     'FontSize',11,...
% %     'FontName','Times')
% % title('Reward values for CEM and Random Shooting');
% % xlabel('time')
% % ylabel('Reward Value');
% % legend('CEM','Random Shooting');
% % 
% % print -depsc2 cem_randshoot.eps
% 
% 
% plot([1:49],cem_std(1:49,1),'-ob',...
%     [1:49],cem_std(1:49,2),'-*b',...
%     [1:49],cem_std_c(1:49,1),'--ok',...
%     [1:49],cem_std_c(1:49,2),'--*k');
% set(gca,...    
%     'FontUnits','points',...
%     'FontWeight','normal',...
%     'FontSize',11,...
%     'FontName','Times');
%  title('Convergence of Values in CEM');
%  xlabel('Time')
%  ylabel('Standard Deviation');
%  legend('CEM w/ limits : Rear Motor','CEM w/ limits : Front Steering','CEM w/o limits : Rear Motor','CEM w/o limits : Front Steering');
% axis([1 49  -0.5 1]);
% print -depsc2 cem_conv.eps

%% Reward funct plot
% Cp = [100 100 300 500 100 100 300 500 500 300 500 800 100];
% Ch = [100 100 100 100 300 500 300 500 500 500 300 800 500];
% Cv = [10 50 10 10 10 10 10 10 50 50 50 50 50];
% rms = [2 3 2.4 2.9 3.5 4.2 3.5 3.0 1.8 1.3 2.8 2.2 2.0];
% % scatter3(Cp,Ch,Cv,rms,'filled');
% % %surf(Cp,Ch,Cv,rms);
% % cb = colorbar;
% % cb.Label.String = 'Trajectory RMSE (cm)';
% 
% N = 50 ;
% 
% xi = repmat(Cp,size(Cp,2),1);
% yi = repmat(Ch,size(Ch,2),1);
% zi = repmat(Cv,size(Cp,2),1);
% qi = repmat(rms,13,1);
% %d = -1:0.05:1;
% %[xq,yq,zq] = meshgrid(d,d,0) ;
% %vq = griddata(Cp,Ch,Cv,rms,xq,yq,zq) ;
% %surf(xq,yq,zq,vq);
% %scatter3(Cp,Ch,Cv);
% surf(xi,yi,zi,rms);
% cb = colorbar;
% cb.Label.String = 'Trajectory RMSE (cm)';
% %plot3(Cp,Ch,Cv,rms);

%% robust traj
pts = 50;
interval = 20/pts; %-1 to 1
[x, y] = meshgrid(-10:interval:10, -10:interval:10);

  z = [0.5*sin((4*pi/20)*x)] .* [0.5*sin((4*pi/20)*y)];
 z = z + 0.25;

 fprintf("max ht %f",max(max(z)));
fprintf("min ht %f",min(min(z)));

 load('trc_data_sync_dsin_8x50','xyzphi_store');
 a = csvread('dsin_curve_right_rob_f.csv');
 b = csvread('dsin_straight_line_rob_f.csv');
figure('Units','inches', ...
'Position',[2 2 8 6], ...
'PaperPositionMode','auto');

surf(x,y,z);
axis([-10 10 -10 10 0 2]);
hold on;
plot3(xyzphi_store(:,1),-xyzphi_store(:,2),xyzphi_store(:,3),'*k','LineWidth',2);
hold on;
plot3(a(:,1),-a(:,2),a(:,3),'-*r','LineWidth',5);
hold on;
plot3(b(:,1),-b(:,2),b(:,3),'-*r','LineWidth',5);


set(gca,...    
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',11,...
    'FontName','Times')
title('Robust Testing');
xlabel('X');
ylabel('Y');
zlabel('Z');
