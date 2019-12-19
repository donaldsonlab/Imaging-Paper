%Ryan Cameron - Donaldson Lab, University of Colorado Boulder
%Created:  12/18/2019
%Modified: 12/18/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script takes the novel and partner median distance permutation data
%that was split up into first and last 10 minutes and runs some
%significance analysis on the data. It outputs four new tables that have
%the necessary info in them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

animals = [ 440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599]; %List of animals

%Setup the table
results_significance_opposite_last_10 = table(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16);
VariNames = {'Animal','Epoch','p_cells','p_025','p_05','p_10','p_975','p_95','p_90','n_cells','n_025','n_05','n_10','n_975','n_95','n_90'};
results_significance_opposite_last_10.Properties.VariableNames = VariNames;

dataVec = ["P_opposite_last_10.mat","N_opposite_last_10.mat"];

check = 1;
for name = dataVec
    load(name);
    if check == 1
        P_opposite_last_10.Var4 = [];
        data = table2array(P_opposite_last_10);
    elseif check == 2
        N_opposite_last_10.Var4 = [];
        data = table2array(N_opposite_last_10);
    end
    count = 1;
    for an = animals %Loop through each animal
        for ep = 1:3 %Loop through each epoch
            
            %Single out the data specific to animal/epoch
            index = find((data(:,1) == an) & (data(:,2) == ep));
            dataSmall = data(index,:);
            
            %Find number of cells that had events
            ind_events = find(~isnan(dataSmall(:,4)));
            num_cells = length(ind_events);
            
            %% Find significance variables
            %Find how many of those cells had p-vals < .025
            index_p025 = find(dataSmall(:,5) <= 0.025);
            num_cells_025 = dataSmall(index_p025,:);
            num_025 = length(num_cells_025)/num_cells;
            %<.05
            index_p05 = find(dataSmall(:,5) <= 0.05);
            num_cells_05 = dataSmall(index_p05,:);
            num_05 = length(num_cells_05)/num_cells;
            %<.10
            index_p10 = find(dataSmall(:,5) <= 0.1);
            num_cells_10 = dataSmall(index_p10,:);
            num_10 = length(num_cells_10)/num_cells;
            
            %How many cells had p-vals > .975
            index_p975 = find(dataSmall(:,5) >= 0.975);
            num_cells_975 = dataSmall(index_p975,:);
            num_975 = length(num_cells_975)/num_cells;
            %>.95
            index_p95 = find(dataSmall(:,5) >= 0.95);
            num_cells_95 = dataSmall(index_p95,:);
            num_95 = length(num_cells_95)/num_cells;
            %>.90
            index_p90 = find(dataSmall(:,5) >= 0.90);
            num_cells_90 = dataSmall(index_p90,:);
            num_90 = length(num_cells_90)/num_cells;
            
            %% Assign Variables to table
            if check == 1
                results_significance_opposite_last_10(count,1:9) = table(an,ep,num_cells,num_025,num_05,num_10,num_975,num_95,num_90);
                count = count + 1;
            elseif check == 2
                results_significance_opposite_last_10(count,10:16) = table(num_cells,num_025,num_05,num_10,num_975,num_95,num_90);
                count = count + 1;
            end
        end
    end
    check = 2;
end
writetable(results_significance_opposite_last_10,'results_significance_opposite_last_10.xlsx')

