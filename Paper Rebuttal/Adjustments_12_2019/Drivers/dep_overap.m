%Find which cells are both partner and novel departure

clear all; close all; clc;

cd ..
cd Data_No_Check
load('N_all_time.mat')
load('P_all_time.mat')

index_P = find(P_all_time.P_val >= 90);
P_dep = P_all_time(index_P,:);

index_N = find(N_all_time.P_val >= 90);
N_dep = N_all_time(index_N,:);

%Now find the overlap
index_both = intersect(index_P,index_N);
overlap_cells = P_all_time(index_both,1:3);