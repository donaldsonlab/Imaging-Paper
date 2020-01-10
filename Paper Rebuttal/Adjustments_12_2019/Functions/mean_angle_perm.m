%Ryan Cameron - University of Colorado, Donaldson Lab
%Created: 1/10/2020
%Edited:  1/10/2020
%--------------------------------------------------------------------------
%This function outputs the MEAN angle value between before and after event
%vectors (<180 ALWAYS) for a cell and then also a p-value based on a
%permutation where the events are shuffled and the calculation is redone. 
%INPUTS:  cell events vector
%         behavior matrix
%OUTPUTS: angle
%         p-value
%--------------------------------------------------------------------------

function [theta,p_val] = mean_angle_perm(cell_vec,behavior)
event_index = find(cell_vec);
num_events = length(event_index);
event_loc = behavior(event_index,2:3);

%Correlate those indices with the behavior matrix
before_index = event_index - 5;
before_index(find(before_index < 1)) = 1;
before_loc = behavior(before_index,2:3); %x and y
before_vec = event_loc - before_loc;

after_index = event_index + 5;
after_index(find(after_index > length(after_index))) = length(after_index);
after_loc = behavior(after_index,2:3);
after_vec = after_loc - event_loc;

%Find the angle with the dot product
cos_theta = (dot(before_vec,after_vec))./(hypot(before_vec(:,1),before_vec(:,2))*hypot(after_vec(:,1),after_vec(:,2)));
theta = acosd(cos_theta);
theta = mean(theta);
if theta > 180
    theta = 360 - theta;
end

%Now run the permutation
for perm = 1:1000
    cell_vec_perm = cell_vec(randperm(length(cell_vec))); %Shuffles the events
    event_index_perm = find(cell_vec_perm);
    event_loc_perm = behavior(event_index_perm,2:3);
    
    before_index_perm = event_index_perm - 5;
    before_index_perm(find(before_index_perm < 1)) = 1;
    before_loc_perm = behavior(before_index_perm,2:3);
    before_vec_perm = event_loc_perm - before_loc_perm;
    
    after_index_perm = event_index_perm + 5;
    after_index_perm(find(after_index_perm > length(after_index_perm))) = length(after_index_perm);
    after_loc_perm = behavior(after_index_perm,2:3);
    after_vec_perm = after_loc_perm - event_loc_perm;
    
    %Find the angle
    cos_theta_perm = (dot(before_vec_perm,after_vec_perm))./(hypot(before_vec_perm(:,1),before_vec_perm(:,2))*hypot(after_vec_perm(:,1),after_vec_perm(:,2)));
    theta_perm(perm) = mean(acosd(cos_theta_perm));
    if theta_perm(perm) > 180
        theta_perm(perm) = 360 - theta_perm(perm);
    end
end
%DON'T KNOW IF THIS IS CORRECT WAY TO FIND THE PVAL WE WANT
p_val = length(find(theta_perm < theta))/1000 * 100;
end