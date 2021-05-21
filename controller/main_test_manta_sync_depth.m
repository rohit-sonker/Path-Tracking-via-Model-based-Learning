clear;
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m) 
  vrep.simxFinish(-1); % just in case, close all opened connections
  clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
  
%load network and action norm
% load ('deepnet_sync_depth2_dsin_4x50');
% load ('deepnet_sync_4x50');
% load('deepnet6_500_sync_depth_dsinhf3_4x50');
load('deepnet_sync_depth_all_4x50','deepnet_c1');
netuse = deepnet_c1;


% load('net_dsin_r05');
% netuse = deepnet_c1;

load('action_norm_sync_depth_sin_4x50','actioncolmean','actioncolstd');
%change parameter in normdatapoint3d !  

% htdepth = 0.5; %dsinhf2
% htdepth = 1; %incl1
% htdepth = 0.5; %sinhf %dsin
% htdepth = 0.1; %dsinhf3

% varying ht diff for dsin
htdepth=0.5;

% diif drive
kw=5;
kv=10;

set(gcf,'renderer','painters');
if (clientID>-1)
disp('Connected to remote API server !');

% enable the synchronous mode on the client:
vrep.simxSynchronous(clientID,true);
% start the simulation:
vrep.simxStartSimulation(clientID,vrep.simx_opmode_blocking);

%get robot and motor handles
[returnCode, robot_handle] = vrep.simxGetObjectHandle(clientID, 'Manta', vrep.simx_opmode_blocking);        
[returnCode,rear_motor] = vrep.simxGetObjectHandle(clientID,'motor_joint', vrep.simx_opmode_blocking);
[returnCode, front_steer] = vrep.simxGetObjectHandle(clientID,'steer_joint', vrep.simx_opmode_blocking);

%get trajectory
traj = csvread('dsinhf3_curve_left2.csv');
% traj = csvread('dsinhf3_straight_line2.csv');
% traj = csvread('flat_straight_line.csv');
traj = traj(1:size(traj,1),1:3);
curr_pt = 1; %this can extract the pt and segment
curr_seg = curr_pt;
curr_fw = 0;

%get object init state and orientation
[returnCode,position]=vrep.simxGetObjectPosition(clientID, robot_handle, -1 ,vrep.simx_opmode_buffer);
[returnCode,euler]=vrep.simxGetObjectOrientation(clientID, robot_handle, -1 ,vrep.simx_opmode_buffer);

state = [position, cos(euler(1)), sin(euler(1)), cos(euler(2)), sin(euler(2)), cos(euler(3)), sin(euler(3))];

%CHANGE !!!!!
state_d = get_htdiff(state,htdepth);                 

%defining variables
dt = 4; % x50ms of sim
t = 2000;
rewards_na = zeros(t,1);
rewards_n = zeros(t,1);
maxcumreward = zeros(t,1);
errors = zeros(t,6);
herror = zeros(t,1);
pos = zeros(t,6);
traj_errors = zeros(t,1);
checkstate = 1;
i=1;

%to cure initial value zeros
[returnCode,position]=vrep.simxGetObjectPosition(clientID, robot_handle, -1 ,vrep.simx_opmode_streaming);
[returnCode,euler]=vrep.simxGetObjectOrientation(clientID, robot_handle, -1 ,vrep.simx_opmode_streaming);
    

while checkstate==1
   
    tic;
    %[action, maxcumreward(i), curr_seg] = mpcontr_manta(state,traj,2,400,netuse, actioncolmean,actioncolstd, curr_seg);
    %[action, maxcumreward(i), curr_segn, si] = mpcontr_manta_cem(state,traj,2,800,netuse, actioncolmean,actioncolstd, curr_seg);
%     [action, maxcumreward(i), curr_segn, si] = mpcontr_manta_cem(state,traj,2,200,netuse, actioncolmean,actioncolstd, curr_seg);
    
    [action, maxcumreward(i), curr_segn, si] = mpcontr_manta_cem_depth(state_d,traj,4,200,netuse, actioncolmean,actioncolstd, curr_seg,htdepth);
%     [action,maxcumreward(i), curr_seg, si] = diff_drive_contr(state,traj, curr_seg, kw,kv);
    
    
    tme_taken(i) = toc; 
    a_temp(i,:) = action(:);
    fprintf('\n \n action %f %f',action(1), action(2));
    fprintf('\n std %f %f', si(1), si(2));
    std_store(i,:) = si(:);
        
    %apply action
    [returnCode]= vrep.simxSetJointTargetVelocity(clientID, rear_motor, action(1), vrep.simx_opmode_blocking);
    [returnCode] = vrep.simxSetJointTargetPosition(clientID, front_steer, action(2), vrep.simx_opmode_blocking);
    %pause or simwait
    tic;
    
    %run sim
    for timestep = 1:dt
        vrep.simxSynchronousTrigger(clientID);
    end;
    
    %now get location again and update state
    [returnCode,position]=vrep.simxGetObjectPosition(clientID, robot_handle, -1 ,vrep.simx_opmode_streaming);
    [returnCode,euler]=vrep.simxGetObjectOrientation(clientID, robot_handle, -1 ,vrep.simx_opmode_streaming);
    
   
     t1  = toc;
    nextstate = [position, cos(euler(1)), sin(euler(1)), cos(euler(2)), sin(euler(2)), cos(euler(3)), sin(euler(3))];
    
   
    
        %predicting and storing for curve plot -- FIX TO ACTUAL ACTION
    %[state_n1, action_n1] = norm_datapoint_manta(state,action,actioncolmean,actioncolstd);
    
    state_d = get_htdiff(state,htdepth);
    [state_n1, action_n1] = norm_datapoint_manta3d(state_d,action,actioncolmean,actioncolstd);
%     
%     [state_n1, action_n1] = norm_datapoint_manta3d(state,action,actioncolmean,actioncolstd);
    
    Xts = [state_n1, action_n1]; 
    pred = predict(netuse,Xts');
    
    predstate = pred' + state;
    curr_fw = 0;
    
    %[curr_reward(i),temp1,temp2,p_term(i),h_term(i),f_term(i), des_gamma] = manta_rewardfn(predstate, traj, curr_seg, curr_fw);
    [curr_reward(i),temp1,temp2,p_term(i),h_term(i),f_term(i), des_gamma] = manta_rewardfn_f(nextstate,action, traj, curr_seg, curr_fw);
    %[curr_reward(i),temp1,temp2,p_term(i),h_term(i),f_term(i), des_gamma] = manta_rewardfn_pos(nextstate,action, traj, curr_seg, curr_fw);
    
    %prediction errors
    aerror = atan2(nextstate(5),nextstate(4)) - atan2(predstate(5),predstate(4));
    berror = atan2(nextstate(7),nextstate(6)) - atan2(predstate(7),predstate(6));
    gerror = atan2(nextstate(9),nextstate(8)) - atan2(predstate(9),predstate(8));
    errors(i,1:3) = nextstate(1:3) - predstate(1:3);
    errors(i,4:6) = [aerror, berror, gerror];
    
    %update state
    state = nextstate;
    state_d = get_htdiff(state,htdepth);
    
    %checking end and storing states
    [curr_seg, traj_errors(i), curr_fw,xd(i),yd(i),zd(i)] = check_segment_manta(state, traj, curr_seg);
    posxyz = state(1:3);
    alpha = atan2(state(5),state(4));
    beta = atan2(state(7), state(6));
    gamma = atan2(state(9), state(8));
    pos(i,:) = [posxyz, alpha, beta, gamma];
    checkstate = checkend_manta(state, traj, 0.5);
    
    t2 = toc;
    
    if rem(i,10)==0 || i==1
    figure(4),plot([1:i], traj_errors(1:i),'-r');
   title('Perpendicular Traj Error (m)');
   figure(7),plot([1:i],curr_reward(1:i),'-k',[1:i],p_term(1:i),'--r',[1:i],h_term(1:i),'--g',[1:i],f_term(1:i),'--b');
   %figure(7),plot([1:i],curr_reward(1:i),'-k');
   title('Current Reward');
   figure(8),plot([1:i], xd(1:i),'-r',[1:i],yd(1:i),'-g',[1:i],zd(1:i),'-b');
   title('Perpendicular Traj Error (m)');
    end  
   i= i+1; 
   %fprintf('\n main. curr_seg %d',curr_seg);
   fprintf('\n gamma = %f , des_gamma = %f, diff = %f',gamma, des_gamma, abs(gamma-des_gamma));
   %fprintf('\n time of sim %f',t1);
   %disp(t2);
end 
traj_rmse = norm(traj_errors(1:i))/sqrt(i);
[returnCode]= vrep.simxSetJointTargetVelocity(clientID, rear_motor, 0, vrep.simx_opmode_blocking);
[returnCode] = vrep.simxSetJointTargetPosition(clientID, front_steer, 0, vrep.simx_opmode_blocking);
vrep.simxFinish(-1);

figure(5),plot([1:i-1],errors(1:i-1,1),'-b',[1:i-1],errors(1:i-1,2),'-g',[1:i-1],errors(1:i-1,3),'-k',...
    [1:i-1],errors(1:i-1,4),'--b',[1:i-1],errors(1:i-1,5),'--g',[1:i-1],errors(1:i-1,6),'--k');
title('errors in xyphi');

fprintf('\n\n traj rmse = %f',traj_rmse);
fprintf('\n\n comp time = %f',mean(tme_taken));
end
vrep.delete();
  