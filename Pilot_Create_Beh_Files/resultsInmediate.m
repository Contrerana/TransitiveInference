function T=resultsInmediate(folder1, group,ID,cond)
% Convert in a table all the results for the participant files in 'folder'
% This is only valid for those seeing premises only in session 1
% Inputs:
%       folder1: complete path to the participant files for session1
%       group:  wake/sleep to add it to the output
%       ID: participant identification
%       cond: condition all (all pairs in S1) or prem (only premise pairs
%       in S1)
% Output:
%       res: table with all the parameters needed to do stats
%
%
% Lorena Santamaria (c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find out the number of blocks participant has done (should be 4)
no_blocks=numel(dir(fullfile(folder1,'*.mat')));
% read the info and put it nicely
% acc of premises pairs for each hierarchy per each block
T=table();
for b=1:no_blocks
    name=[ID '_Immediate_Session_1_Block_' num2str(b) '.mat'];
    load(fullfile(folder1,name));%Result:1 x 30 trials (10 each hierarchy)
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
        errordlg('NoPics and RT different');return;
    end
    % find out the category/condition/premise pair
    temp=IdentifyPremisesPairs(ID,Horder,PicsNo,Img,Answers,RT,'S1',b,group,cond);
    % create a temporal table
    temp=struct2table(temp);
    % update table
    T=[T;temp];  
end