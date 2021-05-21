%expand dataset to include depth
clear all;
% load('v_data_sync_dsin_4x50','Xtr1','tar1','xyzphi_store');

load('trc6_data_sync_depth_dsinhf3_4x50','Xtr1','tar1','xyzphi_store');

% load('v_data_sync_dsin_4x50','Xtrc','tarc','xyzphi_store');

%Xtr1 = Xtrc;

%denormalise
xlim = [-10 10];
ylim = [-10 10];
% zlim = [0 2.5];   %incline
% zlim = [0 1.5]; %1m incline
%  zlim = [0 0.6];   %sin
zlim = [0 0.75]; %doublesin

%without xyzphi
actual(:,1) = Xtr1(:,1)*(xlim(2) - xlim(1)) + mean(xlim);
actual(:,2) = Xtr1(:,2)*(ylim(2) - ylim(1)) + mean(ylim);
actual(:,3) = Xtr1(:,3)*(zlim(2) - zlim(1)) + mean(zlim);


rad_ht = 0.5;

% org_state = [actual(:,1:3), Xtr1(:,4:9)];

org_state = xyzphistore;

for i=1:size(org_state,1)
    state_d(i,:) = get_htdiff(org_state(i,:),rad_ht);
end

% Xtr_new = [Xtr1(:,1:9), state_d(:,10:14), Xtr1(:,10:11)];
% 
% Xtr1 = Xtr_new;
% Xtrc = Xtr_new;

% new way
xlim = [-10 10];
ylim = [-10 10];
zlim = [0 0.3]; %dsinhf3
state_n(:,1) = (state(:,1) - mean(xlim))/ (xlim(2) - xlim(1));
state_n(:,2) = (state(:,2) - mean(ylim))/ (ylim(2) - ylim(1));
state_n(:,3)  = (state(:,3) - mean(zlim))/ (zlim(2) - zlim(1));

save('tr_data_sync_depth_dsin_4x50_r09','Xtr1','tar1');
%save('v_data_sync_depth_dsin_4x50','Xtrc','tarc','xyzphi_store');