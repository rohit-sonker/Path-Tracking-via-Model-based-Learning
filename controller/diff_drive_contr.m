%MPC Model Predictive Controller

function [action,maxcumreward, curr_seg, si] = diff_drive_contr(state,traj, curr_seg, kw,kv) 

currpos = [state(1), state(2), state(3)];
curr_start = traj(curr_seg,:);
curr_end = traj(curr_seg+1,:);

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
        if curr_seg<size(traj,1)-1
            curr_seg = curr_seg+1;
        end
        
else
    closestpt = curr_start + which_line * b;
    goal_pt = curr_end;
end

% goal_pt = closestpt;
% goal_pt = traj(curr_seg,:);

goal_v = goal_pt - currpos;
d = norm(goal_v);

robot_gamma = atan2(state(9), state(8));
goal_vn = goal_v/d;
b_n = b/norm(b);
% req_gamma = atan2(-goal_vn(1), goal_vn(2));
req_gamma = atan2(-b_n(1), b_n(2));

req_w = req_gamma - robot_gamma;

% get error in heading
w = kw*req_w;

if(w>1)
    w=1;
elseif(w<-1)
    w=-1;
end

%get d from next point

% v = kv*norm(goal_v)*cos(req_gamma);
v = kv*cos(req_gamma);

if v>5
    v=5;
end

action = [v,w];

maxcumreward = 0;

si=[0,0];
end