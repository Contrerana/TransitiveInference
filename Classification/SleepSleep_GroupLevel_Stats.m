%% SLEEP-SLEEP for CL-TMR GROUP LEVEL
% Classes: Up/Down of the SO and experimental vs control sounds
% This is for the Up: experimental vs down and Down: experimental vs sounds
% Stimuli: faces, objects and scenes
% Lorena Santamaria Feb-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set-up
run('MATLAB/Toolboxes/fieldtrip-20200310/ft_defaults.m'); %fieldtrip path
addpath(genpath('MATLAB/Toolboxes/MVPA')); % classification toolbox
% files paths
SleepFiles='/home/sapls6/Documents/MATLAB/CL_TMR_Dec2020/FieldtripResults/ReReferenced/';  %separated by condition: 19 pt X 4
SavingPath='/home/sapls6/Documents/MATLAB/CL_TMR_Dec2020/Classification_Sleep_Sleep/'; 
% List of files for each participant
ListSleep=dir(fullfile(SleepFiles,'*.mat'));ListSleep={ListSleep.name}';
% participants ID
ID=cellfun(@(x) extractBetween(x,'CleanReReferenced_P','Sleep'),ListSleep,'Un',0);
ID=table2cell(unique(cell2table(ID)));
%% DO LOOP
resultsUp = cell(numel(ID), 1);resultsDown = cell(numel(ID), 1);
for pt=1:numel(ID)
    %% get the wake data (2 classes/2 sessions)
    idx=contains(ListSleep,[ID{pt} 'Sleep']); %ideally 4 files
    NamesToLoad=ListSleep(idx);
    % load all the files and put the together 
    down_cont=load([SleepFiles NamesToLoad{1}]);down_cont=down_cont.timelock;
    down_exp=load([SleepFiles NamesToLoad{2}]);down_exp=down_exp.timelock;
    up_cont=load([SleepFiles NamesToLoad{3}]);up_cont=up_cont.timelock;
    up_exp=load([SleepFiles NamesToLoad{4}]);up_exp=up_exp.timelock;
    clear('idx','Names');
    %% Prepare things for the toolbox for Down condition
    time_sec=down_cont.time;
    % trial field needs to be a matrix not a cell of trials by channels by time
    % with both conditions together
    Down_ExpCtrl=cat(1,down_exp.trial,down_cont.trial); % trials both by 60 channel x time points
    % we create the labels for the classifiers (one for each trial)
    no_trials_exp=size(down_exp.trial,1);
    no_trials_ctrl=size(down_cont.trial,1);
    Dlabels=[ones(1,no_trials_exp,1) 2*ones(1,no_trials_ctrl)]'; %exp :1 ctrl: 2
    % numel(labels) has to be the same size than size(ExpCtrl,1) !!!
    clear('down_exp','down_cont');
    %% Prepare things for the toolbox for Up condition
    % trial field needs to be a matrix not a cell of trials by channels by time
    % with both conditions together
    Up_ExpCtrl=cat(1,up_exp.trial,up_cont.trial); % trials both by 60 channel x time points
    % we create the labels for the classifiers (one for each trial)
    no_trials_exp=size(up_exp.trial,1);
    no_trials_ctrl=size(up_cont.trial,1);
    Ulabels=[ones(1,no_trials_exp,1) 2*ones(1,no_trials_ctrl)]'; %exp :1 ctrl: 2
    % numel(labels) has to be the same size than size(ExpCtrl,1) !!!
    clear('up_exp','up_cont','no_trials_exp','no_trials_ctrl');
     %% classification
    cfg=[];
    % zscore: normalise data within the fold
    % undersample: balance no trials per class so we dont introduce bias
    % pca: dimensionality reduction: 60 channels is a lot 
    cfg.preprocess={'zscore','undersample','pca'}; 
    cfg.k=5; %5 folds cross-validation
    cfg.repeat=2; % repeat the 5-fold twice
    cfg.classifier='svm';
    cfg.metric={'auc','acc'}; % area under the curve and acc as performance mtric
    [~,resultsDown{pt}] = mv_classify_across_time(cfg,Down_ExpCtrl,Dlabels);
    [~,resultsUp{pt}] = mv_classify_across_time(cfg,Up_ExpCtrl,Ulabels);
    % plotting
    results{1}=resultsUp{pt};
    results{2}=resultsDown{pt};
    result_merge = mv_combine_results(results, 'merge');
    result_merge = mv_select_result(result_merge, 'auc'); % select AUC only just for plotting
    mv_plot_result(result_merge,time_sec);legend({'Up','Down'});
    title(['Participant ' ID{pt} ' AUC performance']);
    fprintf('Participant %d done\n',pt);
end
%% save it
save('Results_Allparticipants_Sleep_Sleep.mat','resultsUp','resultsDown');
%% PLOT Grand average
result_average_auc_up = mv_combine_results(resultsUp, 'average');
result_average_auc_up = mv_select_result(result_average_auc_up, 'auc');
result_average_auc_down = mv_combine_results(resultsDown, 'average');
result_average_auc_down = mv_select_result(result_average_auc_down, 'auc');

mv_plot_result({result_average_auc_up result_average_auc_down},time_sec);
legend({'Up','Down'});

result_average_acc_up = mv_combine_results(resultsUp, 'average');
result_average_acc_up = mv_select_result(result_average_acc_up, 'acc');
result_average_acc_down = mv_combine_results(resultsDown, 'average');
result_average_acc_down = mv_select_result(result_average_acc_down, 'acc');

mv_plot_result({result_average_acc_up result_average_acc_down},time_sec);
legend({'Up','Down'});
%% DO STATS (similar to fieldtrip) fo AUC
cfg_stat = [];
cfg_stat.metric          = 'auc';
cfg_stat.test            = 'permutation';
cfg_stat.correctm        = 'cluster';  % correction method is cluster
cfg_stat.n_permutations  = 1000;
cfg_stat.clusterstatistic = 'maxsum';
cfg_stat.alpha           = 0.05; % use standard significance threshold of 5%
cfg_stat.design          = 'within'; %within participant desing
cfg_stat.statistic       = 'wilcoxon'; %non parametrics
cfg_stat.null            = 0.5; % over chance level
cfg_stat.clustercritval  = 1.96;% z-val = 1.96 corresponds to uncorrected p-value = 0.05
stat_sleep_sleep_auc_Up = mv_statistics(cfg_stat, resultsUp);
stat_sleep_sleep_auc_Down = mv_statistics(cfg_stat, resultsDown);

% plot with mask of p values
mv_plot_result(result_average_auc_up,time_sec, 'mask',stat_sleep_sleep_auc_Up.mask);
mv_plot_result(result_average_auc_down,time_sec, 'mask',stat_sleep_sleep_auc_Down.mask);
%% DO STATS (similar to fieldtrip) fo ACC
cfg_stat = [];
cfg_stat.metric          = 'acc';
cfg_stat.test            = 'permutation';
cfg_stat.correctm        = 'cluster';  % correction method is cluster
cfg_stat.n_permutations  = 1000;
cfg_stat.clusterstatistic = 'maxsum';
cfg_stat.alpha           = 0.05; % use standard significance threshold of 5%
cfg_stat.design          = 'within'; %within participant desing
cfg_stat.statistic       = 'wilcoxon'; %non parametrics
cfg_stat.null            = 0.5; % over chance level
cfg_stat.clustercritval  = 1.96;% z-val = 1.96 corresponds to uncorrected p-value = 0.05
stat_sleep_sleep_acc_Up = mv_statistics(cfg_stat, resultsUp);
stat_sleep_sleep_acc_Down = mv_statistics(cfg_stat, resultsDown);

% plot with mask of p values
mv_plot_result(result_average_acc_up,time_sec, 'mask',stat_sleep_sleep_acc_Up.mask);
mv_plot_result(result_average_acc_down,time_sec, 'mask',stat_sleep_sleep_acc_Down.mask);
%% DO STATS BETWEEN for AUC
cfg_stat = [];
cfg_stat.metric          = 'auc';
cfg_stat.test            = 'permutation';
cfg_stat.correctm        = 'cluster';  % correction method is cluster
cfg_stat.n_permutations  = 1000;
cfg_stat.clusterstatistic = 'maxsum';
cfg_stat.alpha           = 0.05; % use standard significance threshold of 5%
cfg_stat.design          = 'between'; %within participant desing
cfg_stat.statistic       = 'wilcoxon'; %non parametrics
cfg_stat.null            = 0.5; % over chance level
cfg_stat.clustercritval  = 1.96;% z-val = 1.96 corresponds to uncorrected p-value = 0.05
%the design
all_results = [resultsUp; resultsDown];
cfg_stat.group = [ones(numel(ID),1); 2*ones(numel(ID),1)];
% Let's run the analysis
stat_Up_Down= mv_statistics(cfg_stat, all_results);
% and plot with the mask (if any)
Up_and_Down_average_auc = mv_combine_results({result_average_auc_up, result_average_auc_down}, 'merge');
mv_plot_result(Up_and_Down_average_auc, time_sec, 'mask', stat_Up_Down.mask);legend('Up','Down');

%% DO STATS BETWEEN for AcC
cfg_stat = [];
cfg_stat.metric          = 'acc';
cfg_stat.test            = 'permutation';
cfg_stat.correctm        = 'cluster';  % correction method is cluster
cfg_stat.n_permutations  = 1000;
cfg_stat.clusterstatistic = 'maxsum';
cfg_stat.alpha           = 0.05; % use standard significance threshold of 5%
cfg_stat.design          = 'between'; %within participant desing
cfg_stat.statistic       = 'wilcoxon'; %non parametrics
cfg_stat.null            = 0.5; % over chance level
cfg_stat.clustercritval  = 1.96;% z-val = 1.96 corresponds to uncorrected p-value = 0.05
%the design
all_results = [resultsUp; resultsDown];
cfg_stat.group = [ones(numel(ID),1); 2*ones(numel(ID),1)];
% Let's run the analysis
stat_Up_Down_acc= mv_statistics(cfg_stat, all_results);
% and plot with the mask (if any)
Up_and_Down_average_acc = mv_combine_results({result_average_acc_up, result_average_acc_down}, 'merge');
mv_plot_result(Up_and_Down_average_acc, time_sec, 'mask', stat_Up_Down_acc.mask);legend('Up','Down');