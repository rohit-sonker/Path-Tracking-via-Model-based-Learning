%reward function2
%implementing as done in code

%input state and action ; trajectory pts ; curr_seg ; prev_forward ;
%move_next

%state = [ 1 2 0 1 0 0 0 ];
%state description = [x,y,cos(phi),sin(phi),vx,vy,w]
%action = [ 0.5 0.5]';

%row wise points
%traj = [1 , 1; 10, 10; 10, 0];
%  
% curr_seg = 2;
% prev_forward = 0.83;
% move_next = 0;
% figure(1);
% axis([-1 15 -1 15]);
% figure(1),plot(state(1), state(2), 'ob');
% hold on;
% figure(1),plot(traj(:,1),traj(:,2),'-*g');
%function [reward, nextstate] = rewardfn_deepnn(state,action,traj,usenet,statecolmean, statecolstd, actioncolmean, actioncolstd)

function [reward, curr_line, curr_forward, p_term,h_term,f_term, des_gamma] = manta_rewardfn_f(state, action, traj, curr_line, prev_forward)
%based on new_rewardfn2
%curr_seg could be zero
move_next = 0;

vel = action(1);
steer = action(2);

%call vrep here to give pts on traj or do the entire math there. i prefer
%here.... more control
%if traj is loaded from csv, then i already have it. what i need is the
%curr pt and update it.

curr_start = traj(curr_line,:);
curr_end = traj(curr_line+1,:);
if curr_line < size(traj,1)-1
    next_start = traj(curr_line+1,:);
    next_end = traj(curr_line+2,:);
else
    next_start = -1;
    next_end = -1;
end

%nextstate = simulator2(state,action);
%use network instead of simulator2
% 
% [state_n1, action_n1] = norm_datapoint(state, action,statecolmean, statecolstd, actioncolmean, actioncolstd); 
%  %X = [pred_s(i,:), actionseq(i,:)];
%  Xts = [state_n1, action_n1];
%  
%  %nextstate = usenet(Xts');
%  nextstate = predict(usenet,Xts');
%  nextstate = nextstate' + state;
% 


currpos = [state(1), state(2), state(3)];
%nextpos = [nextstate(1), nextstate(2)];

%%new method
%for curr_segment
a = currpos - curr_start;
b = curr_end - curr_start;
a_p = (dot(a,b)/dot(b,b)) * b;
which_line = (dot(a,b)/dot(b,b));
if which_line<0
    closestpt = curr_start;
    goal_pt = curr_start;
elseif which_line>1
        closestpt = curr_end;
        goal_pt = curr_end;
else
    closestpt = curr_start + which_line * b;
    goal_pt = curr_end;
end

prev_whichline  = which_line;

%%change hppens
min_dist = norm(currpos - closestpt);
% min_dist = norm(currpos(1:2) - closestpt(1:2));


%curr_forward = norm(a_p);
%move_forward = norm(a_p) - prev_forward;
curr_forward = which_line * norm(b);
move_forward = curr_forward - prev_forward;
des_head = b/ norm(b);


%%%work on a corrective desired heading ?!!!--------------------------

%projections for nextsegment
dist = 1000;
if next_start>0
a = currpos - next_start;
b = next_end - next_start;
a_p = (dot(a,b)/dot(b,b)) * b;
which_line = (dot(a,b)/dot(b,b));
if which_line<0
    closestpt2 = next_start;
elseif which_line>1
        closestpt2 = next_end;
else
    closestpt2 = next_start + which_line * b;
end
    
dist = norm(currpos - closestpt2);
% dist = norm(currpos(1:2) - closestpt2(1:2));


%curr_forward = norm(a_p);
end

if next_start>0
    if dist<min_dist || prev_whichline >= 1
        move_next = 1;
        curr_line = curr_line+1;
        min_dist =dist;
        %curr_forward = norm(a_p);
        curr_forward = which_line;
        %move_forward = norm(a_p);
        move_forward = curr_forward* norm(b);
        des_head = b/norm(b);
    end
end
%%%heading

%robot_head = [state(3), state(4)]; %cos(phi) sin(phi) 
%heading = dot(robot_head, des_head);

%robot_angle = atan2(state(4),state(3)); %2 wheel

%%4 wheel MANTA!

% %new head vector
% goal_v = goal_pt - currpos;
% des_head = goal_v/norm(goal_v);


robot_alpha = atan2(state(5),state(4));
robot_beta = atan2(state(7), state(6));
robot_gamma = atan2(state(9), state(8));

% if robot_angle>pi
%     robot_angle = -pi + rem(robot_angle,pi);
% elseif robot_angle<-pi
%     robot_angle = pi + (robot_angle - (-pi));
% end

des_alpha = atan2(des_head(3), des_head(2));
des_beta = atan2(-des_head(3), des_head(1));
des_gamma = atan2(-des_head(1), des_head(2));

%without 3D Heading
% anglediff = abs(des_gamma - robot_gamma);

%with 3D Heading
% anglediff = abs(des_gamma - robot_gamma) + abs(des_alpha - robot_alpha) + abs(des_beta - robot_beta);
anglediff = abs(des_gamma - robot_gamma);

%new reward
dir = robot_gamma + steer;
dir_diff = abs(dir - des_gamma);
v_comp = vel*cos(dir_diff);

%final terms
p = min_dist;
h = anglediff;
f = v_comp;


% %straight line
%  kp = -500;%-40;
% if min_dist<0.05
%     kp = -200;
% end
%  kh = -100;%-30;
% % if min_dist>2
% %     kh  = 10;
% % end
% kf = 10; %50; %10

%straight line incl
 kp = -500;%-40;
if min_dist<0.05
    kp = -200;
end
 kh = -400;%-30;
% if min_dist>2
%     kh  = 10;
% end
kf = 40; %50; %10

% %curve
%  kp = -500;%-40;
% if min_dist<0.05
%     kp = -200;
% end
%  kh = -100;%-30;
% % if min_dist>2
% %     kh  = 10;
% % end
% kf = 20; %50; %10


p_term = kp*p;
h_term = kh*h;
f_term = kf*f;

reward = kp*p + kh*h + kf*f;
end
