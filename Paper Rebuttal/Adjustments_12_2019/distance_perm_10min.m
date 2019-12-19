%Ryan Cameron
%Created:  6/7/2018
%Modified: 12/6/2018
%--------------------------------------------------------------------------
%This runs a permutation on the mean distance change of an animal in the 
%one second after it experiences a cell event. This is broken into partner
%and novel events (based on the chamber that the animal is in when the
%event occurs), and then this is done for both the first 10 minutes and the
%last ten minutes separately. 
%--------------------------------------------------------------------------

clear all; close all; clc;

animals=[598 599 451 487 543 546 557 573 440 585 586 485 532 535 584 588 445 566 589]; %Vector of animals used (570)

variNames={'Animal','Epoch','Cell','Partner_pVal','Novel_pVal','Partner_Events','Novel_Events','distanceChangeP','distanceChangeN'}; %Names of columns in data table output
resultTable=table(1,2,3,4,5,6,7,8,9); %Initialize the table
resultTable.Properties.VariableNames=variNames;

%Initialize the table with all of the cell data
variNames={'Animal','Epoch','totalCells','pCells','nCells','bothCells'};
cellTable=table(1,2,3,4,5,6);
cellTable.Properties.VariableNames=variNames;
%% PERMUTATION
count10=1;
count20=1;
cellCount=1;
timeSec = 10 * 60; %10 minute span in seconds
results10 = resultTable;
results20 = resultTable;
for an=animals %Loop through each animal
    for ep=1:3 %Loop through each epoch
        [cellsOrig,behaviorOrig]=fileloop(an,ep); %Retrieves the cell data and the behavior data
        
        index10 = [1:find(round(cellsOrig(:,1),2) == round(cellsOrig(1,1) + timeSec,2))]; %Indices of the first 10 minutes
        index20 = [index10(end)+1: size(cellsOrig,1)]; %Indices of the last 10 minutes
        
        for t=[1,2]
            if t == 1
                cells = cellsOrig(index10,:);
                behavior = behaviorOrig(index10,:);
            end
            if t == 2
                cells = cellsOrig(index20,:);
                behavior = behaviorOrig(index20,:);
            end
            cells(:,1)=[]; %Get rid of first column (time points)
            
            pData=[];%zeros(size(cells)); %Pre-allocate matrices for the data
            nData=[];%zeros(size(cells));
            
            %This breaks the data into partner and novel data sets
            for cellNum=1:size(cells,2) %Breaks the data set into partner and novel sets, this is the number of columns in cells, aka, number of cells
                index=find(cells(:,cellNum)); %Isolate one cell (one column)
                for j=index' %Loops through the index of where each event occurs
                    %if behavior(j,16)>behavior(j,17) %Means its a partner cell event, closer to partner than novel
                    if behavior(j,18) == 1
                        pData(j,cellNum)=cells(j,cellNum); %Allocates that line of the event data to pData
                    %elseif behavior(j,16)<behavior(j,17) %Novel cell event, closer to novel than partner
                    elseif behavior(j,20) == 1
                        nData(j,cellNum)=cells(j,cellNum);
                    end
                end
            end
            
            pSum=sum(pData);
            pCells=length(find(pSum)); %Finds which cells actually have events
            nSum=sum(nData);
            nCells=length(find(nSum));
            pSum(find(pSum))=1; %If there was any activity in that cell it gets set to 1
            nSum(find(nSum))=1;
            bothSum=pSum+nSum;
            bothCells=length(find(bothSum==2)); %Finds which cells have activity in partner AND novel
            
            cellTable(cellCount,:)=table(an,ep,size(cells,2),pCells,nCells,bothCells);
            cellCount=cellCount+1;
            %Now that we have the pData and nData sets we can run the
            %permutation on them both
            for cellNum=1:size(cells,2) %For each cell run the permutation
                [partnerVal,novelVal,pEvents,nEvents,pDist,nDist]=perm(pData(:,cellNum),nData(:,cellNum),behavior);
                
                if t == 1
                    results10(count10,:) = table(an,ep,cellNum,partnerVal,novelVal,pEvents,nEvents,pDist,nDist);
                    count10 = count10 +1;
                elseif t == 2
                    results20(count20,:) = table(an,ep,cellNum,partnerVal,novelVal,pEvents,nEvents,pDist,nDist);
                    count20 = count20 + 1;
                end
            end
        end
    end
end

%% Function that runs the actual permutation
function [partnerVal,novelVal,pEvents,nEvents,pDist,nDist]=perm(pVec,nVec,behavior)
permNum=1000; %Number of times the permutation is run

%Find the change in distance 1 second (5 frames) after the event
for np=1:2
    switch np
        case 1 %Partner iteration
            index=find(pVec); %Indexes of the event times
            pEvents=length(index); %Total number of partner events
            if ~isempty(index)
                %Check to make sure events don't occur at end of data set
                if index(end)+5 > length(pVec) %This will get a vector of the distnace changes
                    badInd=find(index+5>length(pVec));
                    newInd=index;
                    newInd(badInd)=length(pVec)-5;
                    pDist=behavior(newInd,17)-behavior(newInd+5,17);
                    pDist(badInd)=behavior(index(badInd),17)-behavior(index(end),17);
                else
                    pDist=behavior(index,17)-behavior(index+5,17); %Change in the distance of the animal for ALL pEvents
                end
            elseif isempty(index)
                pDist=nan;
            end
        case 2
           index=find(nVec); %Indexes of the event times
           nEvents=length(index);
           if ~isempty(index)
               if index(end)+5 > length(nVec)
                   badInd=find(index+5>length(nVec));
                   newInd=index;
                   newInd(badInd)=length(nVec)-5;
                   nDist=behavior(newInd,16)-behavior(newInd+5,16);
                   nDist(badInd)=behavior(index(badInd),16)-behavior(index(end),16);
               else
                   nDist=behavior(index,16)-behavior(index+5,16);
               end
           elseif isempty(index)
               nDist=nan;
           end
    end
end
%This is the real data that things are being compared to.
pDist=median(pDist); %Mean partner cells distance change
nDist=median(nDist);

%Now repeat 1000 times for the permutation
permP=zeros(1,permNum);
permN=zeros(1,permNum);
for i=1:permNum
    permVecP=pVec(randperm(length(pVec))); %Randomizing the whole vector 
    permVecN=nVec(randperm(length(nVec)));
    for np=1:2
        switch np
            case 1
                index=find(permVecP); %Indexes of the events
                if ~isempty(index)
                    if index(end)+5 > length(permVecP)
                        badInd=find(index+5>length(permVecP));
                        newInd=index;
                        newInd(badInd)=length(permVecP)-5;
                        newPDist=behavior(newInd,17)-behavior(newInd+5,17);
                        newPDist(badInd)=behavior(index(badInd),17)-behavior(index(end),17);
                    else
                        newPDist=behavior(index,17)-behavior(index+5,17);
                    end
                else
                    newPDist=nan;
                end
            case 2
                index=find(permVecN); %Indexes of the events
                if ~isempty(index)
                    if index(end)+5 > length(permVecN)
                        badInd=find(index+5>length(permVecN));
                        newInd=index;
                        newInd(badInd)=length(permVecN)-5;
                        newNDist=behavior(newInd,16)-behavior(newInd+5,16);
                        newNDist(badInd)=behavior(index(badInd),16)-behavior(index(end),16);
                    else
                        newNDist=behavior(index,16)-behavior(index+5,16);
                    end
                else
                    newNDist=nan;
                end
        end
    end
    newPDist=median(newPDist); %Mean partner cells distance change
    newNDist=median(newNDist);
    
    permP(i)=newPDist; %partner permutation results
    permN(i)=newNDist; %novel results
end
if isnan(pDist)
    partnerVal=nan;
else
    partnerVal=length(find(pDist>permP))./permNum; %Significant if val > .95
end
if isnan(nDist)
    novelVal=nan;
else
    novelVal=length(find(nDist>permP))./permNum;
end

%     figure(1)
%     subplot(1,2,1)
%     histogram(permP)
%         title('Partner')
%     subplot(1,2,2)
%     histogram(permN)
%         title('Novel')
end
        