%% Changing to fieldtrip and re-reference to mastoids
%
%
% Lorena Santamaria 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set-up
addpath(genpath('/home/sapls6/Documents/MATLAB/CL_TMR_Dec2020')); %wroking folder
run('/home/sapls6/Documents/MATLAB/Toolboxes/fieldtrip-20200310/ft_defaults.m'); %fieldtrip path
run('/home/sapls6/Documents/MATLAB/Toolboxes/eeglab/eeglab.m'); %eeglab path

FilesPath='Cleaned_NoREF/'; %where the eeglab files are
List=dir(fullfile(FilesPath,'*.set'));
List={List.name}'; % only their names are interesting
UpDown=readtable('List_UpDown.csv'); % S100's Up==1 
SavingPath='ReReferenced'; % where the fieldtrip files will be

%% do the work
disp(subject_id);
fname=List{subject_id};
eeg2fieldtrip_myOwn(fname,FilesPath,UpDown,SavingPath); %this save the results so no outputs