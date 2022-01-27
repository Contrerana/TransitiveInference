function T=resultsLate(folder2, group,ID,cond)
% Convert in a table all the results for the participant files in 'folder'
% This isvalid for both groups: all (S1 and S2) or premises only (S2)
% Inputs:
%       folder1: complete path to the participant files for session1 or
%       session 2
%       group:  wake/sleep to add it to the output
%       ID: participant identification
%       cond: all or prem
% Output:
%       res: table with all the parameters needed to do stats
%
%
% Lorena Santamaria (c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find out the number of blocks participant has done (should be 4)
List=dir(fullfile(folder2,'*.mat')); % 4 blocks or 8 depend on condition
no_blocks=length(List);

% read the info and put it nicely
% acc of premises pairs for each hierarchy per each block
T=table();
for b=1:no_blocks
    load(fullfile(folder2,List(b).name)); %Result:1 x 54 trials 
    Horder=Result(1).Hierarchy;%Horder is the hierarchy numbers in the rigth order
    Answers=[Result.correctAns]'; %1 is right 0 mistake
    RT=[Result.RT]';
    PicsNo=[Result.PictShowing]'; % no trials by 2(they appear in pairs)
    % find out the stimuli per category
    Img={Result.image1};
    % check all all the same size or fix it
    if ~isequal(numel(Answers),numel(RT))
        Result=findingMissingAnswer(Result);
        Answers=[Result.correctAns]';
    end
    if ~isequal(size(PicsNo,1),numel(RT))
        PicsNo=Result(1).PictShowing';
    end
    % find out the category/condition/premise pair
    session=extractBetween(List(b).name,'Session_','_Block');
    temp=IdentifyAllPairs(ID,Horder,PicsNo,Img,Answers,RT,['S' session{1}],b,group,cond);
    % create a temporal table
    temp=struct2table(temp);
    % update table
    T=[T;temp];
end