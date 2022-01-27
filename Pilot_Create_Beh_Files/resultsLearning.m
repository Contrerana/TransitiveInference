function T=resultsLearning(folder, group,ID,cond)
% Convert in a table all the results for the participant files in 'folder'
% All conditions/groups did the same learning training
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
% find the file and load it
LearningFile=dir(fullfile([folder '\' ID '_Learning'],'*.mat'));
if numel(LearningFile)>1
    id=strcmp({LearningFile.name},[ID '_Learning_Session_1.mat']);
    LearningFile=LearningFile(id);
end
    
load(fullfile(LearningFile.folder,LearningFile.name));
% find out the number of blocks participant needed to learn
% this is the number of elements in the Result_Total struct
no_blocks=numel(Result_Total);
% read the info and put it nicely
% acc of premises pairs for each hierarchy per each block
T=table();
for b=1:no_blocks
    Block=Result_Total(b).Block;
    %Each block is formed by 30 trials (10 each hierarchy)
    Horder=Block(1).Hierarchy;%Horder is the hierarchy numbers in the rigth order
    Answers=[Block.correctAns]'; %1 is right 0 mistake
    RT=[Block.RT]';
    PicsNo=[Block.PictShowing]'; % no trials by 2(they appear in pairs)
    % find out the stimuli per category
    Img={Block.image1};
    % check all all the same size or fix it
    if ~isequal(numel(Answers),numel(RT))
        Result=findingMissingAnswer(Result);
        Answers=[Block.correctAns]';
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