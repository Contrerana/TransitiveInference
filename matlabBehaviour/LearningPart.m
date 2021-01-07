function T=LearningPart(ID,FilesPath,H)
folder=[FilesPath ID '/' ID '_Learning'];
List=dir(fullfile(folder,'*.mat')); % should be just 1
load([folder '/' List(1).name]); %Result_Total struct: no_blocks x 30 trials
% check acc of premises pairs for each hierarchy per each block
no_blocks=size(Result_Total,2);
for b=1:no_blocks
    Answers=[Result_Total(b).Block.correctAns]'; %1 is right 0 mistake
    RT=[Result_Total(b).Block.RT]';
    PremisePair=[];
end


