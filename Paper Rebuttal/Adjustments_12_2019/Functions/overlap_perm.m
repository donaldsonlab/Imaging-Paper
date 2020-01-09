%Ryan Cameron - University of Colorado, Donaldson Lab
%Created: 1/9/2020
%Edited:  1/9/2020
%--------------------------------------------------------------------------
%This function is the permutation function for all of the overlap scripts
%that are run separately. It outputs a p value for a whole epoch of how
%many overlapping cells there should be. 
%--------------------------------------------------------------------------

function [p_val] = overlap_perm(ep,data,opposite_data,animals,threshold,num_overlap)
for perm = 1:1000
    data_perm = data;
    opposite_perm = opposite_data;
    
    data_perm.P_val = data_perm.P_val(randperm(length(data.P_val)));
    opposite_perm.P_val = opposite_perm.P_val(randperm(length(opposite_data.P_val)));
    
    data_perm = data_perm(find(data_perm.P_val < threshold),:);
    opposite_perm = opposite_perm(find(opposite_perm.P_val < threshold),:);
    
    num_overlap_perm = 0;
    
    for an = animals
        index = find(data_perm.animal == an & data_perm.epoch == ep);
        data_small = data_perm(index,:);
        
        index = find(opposite_perm.animal == an & opposite_perm.epoch == ep);
        data_opp_small = opposite_perm(index,:);
        
        cell_vec = data_small.cell_num;
        cell_vec_opp = data_opp_small.cell_num;
        
        ind_overlap = [];
        for i = 1:length(cell_vec)
            cell = cell_vec(i);
            ind = find(cell_vec_opp == cell);
            ind_overlap = [ind_overlap;ind];
        end
        num_overlap_perm = num_overlap_perm + length(ind_overlap);
    end
    overlap(perm) = num_overlap_perm;
end
p_val = length(find(overlap < num_overlap))/perm *100;
end
