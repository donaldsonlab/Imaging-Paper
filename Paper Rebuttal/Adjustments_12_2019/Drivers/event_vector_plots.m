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

clear all; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];
cd ..
cd Overlaps
load('angle_distance_table_all.mat')

cd ..
cd Data_No_Check
animal_type = 'Partner';
chamber_type = ''; %OR 'opposite'
direction_type = 'approach';
[data_tab] = loadtable(animal_type,chamber_type);

cd ..
cd Functions
for an = animals
    for ep = 1:3
        %Pull the event and bvehavior data
        [events, behavior] = fileloop(an,ep);
        events(:,1) = [];
        events(find(events > 0)) = 1;
        
        %Reduce the size of the angle table to the right animal and epoch
        small_index = find(angle_distance_table_all.Animal == an & angle_distance_table_all.Epoch == ep);
        small_table = angle_distance_table_all(small_index,:);
        
        %Only plot cells with greater than 5 events and less than 15
        small_index = find(small_table.Number_events >=5 & small_table.Number_events <= 15);
        small_table = small_table(small_index,:);
        
        switch direction_type
            case 'approach'
                small_index = find(data_tab.P_val <= 10);
                small_table = small_table(small_index,:);
            case 'departure'
                small_index = find(data_tab.P_val >= 90);
                small_table = small_table(small_index,:);
            otherwise
                error('No direction specified')
        end
        
        cell_list = small_table.Cells;
        for i = cell_list
            cell_vec = events(:,i);
            [~,~,vector_data] = mean_angle_perm(cell_vec,behavior,'no');
            vector_data.after_vec = vector_data.after_vec./norm(vector_data.after_vec);
            u = vector_data.after_vec(:,1);
            v = vector_data.after_vec(:,2);
            x = vector_data.event_loc(:,1);
            y = vector_data.event_loc(:,2);
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