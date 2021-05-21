%function normalise a single point
%input- state action statecolmean statecolstd actioncolmean actioncolstd;
function [state_n, action_n] = norm_datapoint_manta3d(state,action,actioncolmean, actioncolstd)

state_n = zeros(size(state,1) , size(state,2));
action_n = zeros(size(action,1) , size(action,2));

%normalising xy; no need for sinphi cosphi
xlim = [-10 10];
ylim = [-10 10];
% zlim = [0 2.5];   %incline
% zlim = [0 1.5]; %1m incline
% zlim = [0 0.6];   %sin
zlim = [0 0.4]; %sinhhf
% zlim = [0 0.5]; %dsinhf
% zlim = [0 0.75]; %doublesin
% zlim = [0 0.4]; %dsinhf2
% zlim = [0 0.3]; %dsinhf3
state_n(:,1) = (state(:,1) - mean(xlim))/ (xlim(2) - xlim(1));
state_n(:,2) = (state(:,2) - mean(ylim))/ (ylim(2) - ylim(1));
 state_n(:,3)  = (state(:,3) - mean(zlim))/ (zlim(2) - zlim(1));

for i=4:size(state,2)
    state_n(:,i) = state(:,i);
end

for i=1:size(action,2)
    action_n(:,i) = (action(:,i) - actioncolmean(i))/actioncolstd(i);
    %normalise mean 0 std 1;
    
end
end
