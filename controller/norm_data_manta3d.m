%function norm_data
%input = state, action
%output = state_n, action_n, statecolmean, statecolstd
function [state_n, action_n, actioncolmean,actioncolstd] = norm_data_manta3d(state,action)


%statecolmean = mean(state);
%statecolstd = std(state);
actioncolmean = mean(action);
actioncolstd = std(action);

state_n = zeros(size(state,1) , size(state,2));
action_n = zeros(size(action,1) , size(action,2));
% %dont do for x,y,cosphi, sinphi;
% for i=5:size(state,2)
%     state_n(:,i) = (state(:,i) - statecolmean(i))/statecolstd(i);
% end;

%normalising xy; no need for sintheta costheta sinphi cosphi 
xlim = [-10 10];
ylim = [-10 10];
% zlim = [0 2.5];   %incline
% zlim = [0 1.5]; %1m incline
%  zlim = [0 0.6]; %sin
% zlim = [0 0.4]; %sinhhf
% zlim = [0 0.5]; %dsinhf
% zlim = [0 0.75]; %double sin
% zlim = [0 0.4]; %dsinhf2
zlim = [0 0.3]; %dsinhf3
state_n(:,1) = (state(:,1) - mean(xlim))/ (xlim(2) - xlim(1));
state_n(:,2) = (state(:,2) - mean(ylim))/ (ylim(2) - ylim(1));
state_n(:,3)  = (state(:,3) - mean(zlim))/ (zlim(2) - zlim(1));
% state_n(:,3) = state(:,3); %flat
for i=4:size(state,2)
    state_n(:,i) = state(:,i);
end

for i=1:size(action,2)
    action_n(:,i) = (action(:,i) - actioncolmean(i))/actioncolstd(i);
    %normalise mean 0 std 1;
    
end

%action_n = action;
end
