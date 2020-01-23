%Ryan Cameron
%Created: 1/21/2020
%Edited:  1/23/2020
%--------------------------------------------------------------------------
%This script plots some vectors to make sure that the angle calculations
%are reasonable.
%--------------------------------------------------------------------------

clear all; close all; clc;

%Load in the angle data to identify vectors we want to plot
cd ..
cd Overlaps
load('angle_distance_table_all.mat')

%Now identify cells that have a small number of events so we can plot the
%true angle vectors and see what's what there.
ind_small_event = find(angle_distance_table_all.Number_events == 1 & angle_distance_table_all.Number_events > 0);
small_events_table = angle_distance_table_all(ind_small_event,:);

cd ..
cd Functions
angle_vec = small_events_table.Theta_(deg);

for i = 1:size(small_events_table,1)
    an = small_events_table.Animal(i);
    ep = small_events_table.Epoch(i);
    cell_num = small_events_table.Cell(i);
    
    %Now pull the data and plot the angle vectors
    [cells,behavior] = fileloop(an,ep);
    
    %Make the cells matrix only 0's and 1's
    cells(:,1) = []; %Vector of times
    cells(find(cells > 0)) = 1; %Makes all events = 1
    cell_vec = cells(:,cell_num);
    
    %Find the vectors
    event_index = find(cell_vec);
    num_events = length(event_index);
    event_loc = behavior(event_index,9:10);
    
    %Correlate those indices with the behavior matrix
    before_index = event_index - 5;
    before_index(find(before_index < 1)) = 1;
    before_loc = behavior(before_index,9:10); %x and y
    before_vec = event_loc - before_loc;
    
    after_index = event_index + 5;
    after_index(find(after_index > length(after_index))) = length(after_index);
    after_loc = behavior(after_index,9:10);
    after_vec = after_loc - event_loc;
    
    %Plot the vectors
    after_vec = after_vec./norm(after_vec);
    before_vec = before_vec./norm(before_vec);
    xy = [event_loc;event_loc];
    uv = [before_vec;after_vec];
    x = xy(:,1);
    y = xy(:,2);
    u = uv(:,1);
    v = uv(:,2);
    figure
    hold on
    quiver(x,y,u,v)
    grid on
    xlabel('X-direction [pixels]')
    ylabel('Y-direction [pixels]')
    title(sprintf('%.3f Degrees',small_events_table.Theta_(deg)(i)))
end
