%Ryan Cameron - University of Colorado, Boulder
%Donaldson Lab
%Created: 2/14/2020
%Edited:  2/14/2020
%--------------------------------------------------------------------------
%This script creates a sort of circular histogram showing the amount of
%event vectors that are going in each direction for a specific animal,
%epoch, and cell. To do this, all the event vectors are found. Then a 360 
%degree circle is split up into n bins and for each bin there is a range of
%angles. All event vectors in that range of angles is found, and then the
%average vector for that bin is found and the length of that bin is based
%on that averge. 
%--------------------------------------------------------------------------

clear all; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];
n = 24; %number of bins
cd ..
addpath('Functions')

%Get the event vector data from mean_angle_perm
%mean_angle_perm needs the event vector and the behavior data so get those
%first
for an = animals
    for ep = 1:3
        [events,behavior] = fileloop(an,ep);
        
        %Sort the events and behavior according to whatever needs
        
        %Loop through each cell
        cell_num = size(events,2);
        for j = 1:cell_num
            cell_vec = events(:,j);
            %Pull the vector data
            [~,~,vector_data] = mean_angle_perm(cell_vec,behavior,'no');
            after_vec = vector_data.after_vec; %List of vectors that come from the events, just pure distance change here
            
            %From the data, separate into bins.
            %Find the angle each vector is at. Take 0 to be the y-axis.
            theta = atand(after_vec(:,2),after_vec(:,1)); %arctan(y/x) in degrees
            nvec = [0:n-1];
            bin_length = 360/n;
            bins = nvec*bin_length;
            bins(1) = 1;

            %Find the average vector length for that bin

            %Loop through that for each bin.

            %Plot the "circular histogram"