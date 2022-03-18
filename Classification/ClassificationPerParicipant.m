%% SLEEP-SLEEP for CL-TMR PARTICIPANT LEVEL
% Classes: Up/Down of the SO and experimental vs control sounds
% This is for the Up: experimental vs down and Down: experimental vs sounds
% Stimuli: faces, objects and scenes
% 
%
%
% Dependencies: MVPA-light (https://github.com/treder/MVPA-Light)
% Lorena Santamaria Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set-up
disp(subject_id);
addpath(genpath('MATLAB/CL_TMR_Dec2020')); %wroking folder
run('MATLAB/Toolboxes/fieldtrip-20200310/ft_defaults.m'); %fieldtrip path
addpath(genpath('MATLAB/Toolboxes/MVPA')); % classification toolbox
% files paths
SleepFiles='FieldtripResults/ReReferenced/';  %separated by condition: 19 pt X 4
SavingPath=pwd; 
% List of files for each participant
ListSleep=dir(fullfile(SleepFiles,'*.mat'));
ListSleep={ListSleep.name}';
% participants ID
ID=cellfun(@(x) extractBetween(x,'CleanReReferenced_P','Sleep'),ListSleep,'Un',0);
ID=table2cell(unique(cell2table(ID)));
%% call function that actually do the classification and stats
Fname=ID{subject_id};
Results=ClassificationEachParticipant(Fname,ListSleep,SleepFiles);
%% Save it
save([SavingPath 'Permutations_Participant_' Fname '_acc_auc_svm_pca20.mat'],'Results');
