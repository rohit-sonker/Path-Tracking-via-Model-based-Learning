function [curr_seg, min_dist , curr_forwardw] = check_segment_manta(state, traj, curr_seg)

curr_start = traj(curr_seg,:);
curr_end = traj(curr_seg+1,:);
if curr_seg < size(traj,1)-1
    next_start = traj(curr_seg+1,:);
    next_end = traj(curr_seg+2,:);
else
    next_start = nan;
    next_end = nan;
end

%fprintf('\n next_start %d',next_start(:));

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
elseif which_line>1
        closestpt = curr_end;
else
    closestpt = curr_start + which_line * b;
end
prev_whichline  = which_line;    
min_dist = norm(currpos - closestpt);
%curr_forward = norm(a_p) - prev_forward;
curr_forwardw = which_line * norm(b);
%des_head = b/ norm(b);

%projections for nextpoint
dist = 1000;
if ~isnan(next_start)
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
end
%fprintf('\ncheck_segm. min_dis %f and dist %f , prev_wl %f', min_dist,dist,prev_whichline);
if ~isnan(next_start)
    if dist<min_dist || prev_whichline>=1
        move_next = 1;
        curr_seg = curr_seg+1;
        min_dist =dist;
        curr_forwardw = which_line * norm(b);
       % des_head = b/norm(b);
    end
end
end