%Ryan Cameron
%Created: 1/21/2020
%Edited:  1/21/2020
%--------------------------------------------------------------------------
%This function is simlar to fileloop except it pulls the data for the
%freely interacting partner and novel (cell and behavior data both)
%experiments.
%--------------------------------------------------------------------------

function [cells, downsample] = fileloop_free(vole_num,epoch)
PWD = pwd;
cd('G:\My Drive\Donaldson Lab\Vole imaging master data')

voles = [342 345 346 425 431 438 440 445 451];
cohorts = [5 5 5 7 7 7 8 8 8];

index = find(vole_num == voles);
cohort_num = cohorts(index);
vole_num = vole(index);
%If cohort# is less than 10, add 0 to front of number (for filename)
if(cohort_num < 10) 
    cohort_num = sprintf('0%d',cohort_num);
    vole_file = sprintf('C%s_%d',cohort_num,vole_num);
else
    vole_file = sprintf('C%d_%d',cohort_num,vole_num);
end
cd(vole_file)

end