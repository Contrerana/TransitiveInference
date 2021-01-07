function T=InmediateTest(ID,FilesPath,H,Session)
% This function associate to each trial the correct Premise Pair of the
% inmediate test (similar to the learning part) but this time each block
% was saved in a different file
% Inputs:
%    ID is the participants name, hence folder too
%    FilesPath is the main folder containing all participants
%    H is the info of which category and condition 
% Outputs:
%   T: table with all the info for the participant: ID, answers, RTs,....
% Lorena Santamaria (c) 2020

folder=[FilesPath ID '/' ID '_Immediate'];
List=dir(fullfile(folder,'*.mat')); % should be 4 blocks per participant
no_blocks=length(List);
% check acc of premises pairs for each hierarchy per each block
T=table();
for b=1:no_blocks
    load([folder '/' List(b).name]); %Result:1 x 30 trials (10 each hierarchy)
    Horder=Result(1).Hierarchy;%Horder is the hierarchy numbers in the rigth order
    Answers=[Result.correctAns]'; %1 is right 0 mistake
    RT=[Result.RT]';
    PicsNo=[Result.PictShowing]'; % no trials by 2
    % check all all the same size or fix it
    if ~isequal(numel(Answers),numel(RT))
        errordlg('acc and RT different');return;
    end
    if ~isequal(size(PicsNo,1),numel(RT))
        errordlg('NoPics and RT different');return;
    end
    % find out the category/condition/premise pair
    temp=IdentifyPremisesPairs(ID,Horder,PicsNo,H,Answers,RT,Session,b);
    % create a temporal table
    temp=struct2table(temp);
    % update table
    T=[T;temp];
end



       