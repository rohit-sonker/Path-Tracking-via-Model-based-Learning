%MPC Model Predictive Controller
 

function [opt_action,maxcumreward, curr_seg, si] = mpcontr_manta_cem_depth(state,traj,H,K, usenet,actioncolmean, actioncolstd, curr_seg,htdepth) 
persistent mu;
persistent sigma;

if isempty(mu)
    mu(1) = 2.5;
    mu(2) = 0;
end

if isempty(sigma)
    sigma(1) = 1; %0.7
    sigma(2) = pi/5; %pi/9
end

%generate action sequences
kactionseq = zeros(H,2,K); 
cumrewards = zeros(K,1);
%actionseq = zeros(H,2);

kactionseq = action_gen_cem( mu, sigma, H,K);

parfor i = 1:K
    
    cumrewards(i) = cumrewardfn_manta_depth(state, kactionseq(:,:,i), traj,usenet,actioncolmean,actioncolstd,curr_seg,htdepth);
end

[maxcumreward,ind] = max(cumrewards);
opt_action = kactionseq(1, :, ind);

no_elites = 50;
[maxkcum , idk] = maxk(cumrewards, no_elites);
%optk_action = kactionseq(1,:,idk);
optk_action = kactionseq(:,:,idk);

%update mu and sigma;
% action1_top = reshape(optk_action(:,1,:),[no_elites,1]);
% action2_top = reshape(optk_action(:,2,:),[no_elites,1]);


action1_top = reshape(optk_action(:,1,:),[no_elites*H,1]);
action2_top = reshape(optk_action(:,2,:),[no_elites*H,1]);

mu = [mean(action1_top), mean(action2_top)];
sigma = [std(action1_top), std(action2_top)];

if sigma(1) < 0.5
    sigma(1) = 0.5;
end
if sigma(2) < pi/15
    sigma(2) = pi/15;
end

si = sigma;
end