%Ryan Cameron - University of Colorado, Boulder
%Donaldson Lab
%Created: 1/23/2020
%Edited:  1/23/2020
%--------------------------------------------------------------------------
%This script plots all cells that had more than 3 events but less than 15
%events in a way such that teh vector begins at the point in time when the
%event occured and then shows the amount the animal traveled in the 1
%second after the cell event occured.
%--------------------------------------------------------------------------

clearvars; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];
cd ..
cd Overlaps
load('angle_distance_table_all.mat')

cd ..
cd Data_No_Check

animal_type = 'Partner';
chamber_type = ''; %OR 'opposite'
data_tab = loadtable(animal_type,'');
data_tab_opp = loadtable(animal_type,'opposite');

for an = animals
    for ep = 1:3
        
        cd ..
        cd Functions
        %Pull the event and bvehavior data
        [events, behavior] = fileloop(an,ep);
        events(:,1) = [];
        events(find(events > 0)) = 1;
        
        %Reduce the size of the angle table to the right animal and epoch
        small_index = find(angle_distance_table_all.Animal == an & angle_distance_table_all.Epoch == ep);
        data_index = find(data_tab.animal == an & data_tab.epoch == ep);
        data_opp_index = find(data_tab_opp.animal == an & data_tab_opp.epoch == ep);
        
        small_table = angle_distance_table_all(small_index,:);
        small_data = data_tab(data_index,:);
        small_data_opp = data_tab_opp(data_opp_index,:);
        
        if (size(small_table,1)~=size(small_data,1) && size(small_table,1)~=size(small_data_opp,1))
            fprintf('Data Table Not the Same Size')
            pause
        end
        
        %Only plot cells with greater than 5 events and less than 15
        small_index = find(small_table.Number_events >=5 & small_table.Number_events <= 15);
        small_table = small_table(small_index,:);
        small_data = small_data(small_index,:);
        small_data_opp = small_data_opp(small_index,:);
        
        fig = figure;
        for direction_type = ["approach","departure"]
            switch direction_type
                case 'approach'
                    small_index = find(small_data.P_val <= 10);
                    plot_table = small_table(small_index,:);
                    
                    small_index_opp = find(small_data_opp.P_val <= 10);
                    plot_table_opp = small_table(small_index_opp,:);
                    
                    subplot(2,1,1)
                    title('Approach')
                    xlabel('X-Axis [pixels]')
                    ylabel('Y-Axis [pixels]')
                case 'departure'
                    small_index = find(small_data.P_val >= 90);
                    plot_table = small_table(small_index,:);
                    
                    small_index_opp = find(small_data_opp.P_val >= 90);
                    plot_table_opp = small_table(small_index_opp,:);
                    
                    subplot(2,1,2)
                    title('Departure')
                    xlabel('X-Axis [pixels]')
                    ylabel('Y-Axis [pixels]')
                otherwise
                    error('No direction specified')
            end

            %xlim([0 650])
            hold on
            grid on
            plotVecs(fig,plot_table,plot_table_opp,events,behavior)
        end
    end
end

function [data_tab]= loadtable(animal_type, chamber_type)
if isempty(chamber_type)
    file = strcat(animal_type(1),'_all_time');
else
    file = strcat(animal_type(1),'_',chamber_type,'_all_time');
end
filename = strcat(file,'.mat');
data_struct = load(filename);
data_cell = extractfield(data_struct,file);
data_tab = data_cell{1};
data_tab.Var4 = [];
end

function [] = plotVecs(fig,plot_table,plot_table_opp,events,behavior)
figure(fig)
%set(fig,'Visible','off')
cell_list = plot_table.Cell;
for i = cell_list'
    cell_vec = events(:,i);
    [~,~,vector_data] = mean_angle_perm(cell_vec,behavior,'no');
    vector_data.after_vec = vector_data.after_vec./norm(vector_data.after_vec);
    event_index = vector_data.event_index;
    dist = behavior(event_index,17); %Partner
    after_index = vector_data.after_index;
    after_dist = behavior(after_index,17);
    delta_dist = after_dist - dist;
    index_app = find(delta_dist < 0);
    index_dep = find(delta_dist > 0);
    
    u = vector_data.after_vec(index_app,1);
    v = vector_data.after_vec(index_app,2);
    x = vector_data.event_loc(index_app,1);
    y = vector_data.event_loc(index_app,2);
    quiver(x,y,u,v,'g')
    
    u = vector_data.after_vec(index_dep,1);
    v = vector_data.after_vec(index_dep,2);
    x = vector_data.event_loc(index_dep,1);
    y = vector_data.event_loc(index_dep,2);
    quiver(x,y,u,v,'r')
end

% %Now I need to build the opposite approach/departure data
% cell_list = plot_table_opp.Cell;
% for i = cell_list'
%     cell_vec = events(:,i);
%     [~,~,vector_data] = mean_angle_perm(cell_vec,behavior,'no');
%     vector_data.after_vec = vector_data.after_vec./norm(vector_data.after_vec);
%     u = vector_data.after_vec(:,1);
%     v = vector_data.after_vec(:,2);
%     x = vector_data.event_loc(:,1);
%     y = vector_data.event_loc(:,2);
%     quiver(x,y,u,v,'b')
% end
end