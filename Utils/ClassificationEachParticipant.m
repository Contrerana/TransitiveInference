function Results=ClassificationEachParticipant(Fname,ListSleep,SleepFiles)
Results=struct();
%% get the wake data (2 classes/2 sessions)
idx=contains(ListSleep,[Fname 'Sleep']); %ideally 4 files
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
cfg.preprocess={'undersample','zscore','pca'};
cfg.preprocess_param= {};
cfg.preprocess_param{3}= {'n' 20}; % PCA is the 3rd operation, set to 20PACs
cfg.k=5; %5 folds cross-validation
cfg.repeat=2; % repeat the 5-fold twice
cfg.classifier='svm';
cfg.metric={'auc','acc'}; % area under the curve and acc as performance metrics
[~,resultsDown] = mv_classify_across_time(cfg,Down_ExpCtrl,Dlabels);
[~,resultsUp] = mv_classify_across_time(cfg,Up_ExpCtrl,Ulabels);
%% stats per participant
cfgstats = [];
cfgstats.test='permutation';
cfgstats.n_permutations=1000;

fprintf('Starting permutations AUC\n');
cfgstats.metric='auc';
stat_permutation_up_auc = mv_statistics(cfgstats, resultsUp,Up_ExpCtrl,Ulabels);
fprintf('................... UP done\n');
stat_permutation_down_auc= mv_statistics(cfgstats, resultsDown,Down_ExpCtrl,Dlabels);
fprintf('................... DOWN done\n');
fprintf('Starting permutations ACC\n');
cfgstats.metric='acc';
stat_permutation_up_acc= mv_statistics(cfgstats, resultsUp,Up_ExpCtrl,Ulabels);
fprintf('................... UP done\n');
stat_permutation_down_acc= mv_statistics(cfgstats, resultsDown,Down_ExpCtrl,Dlabels);
fprintf('................... DOWN done\n');
%% Add it to the struct output
Results.Up.perf=resultsUp;
Results.Up.stats(1).acc=stat_permutation_up_acc;
Results.Up.stats(2).auc=stat_permutation_up_auc;
Results.Down.perf=resultsDown;
Results.Down.stats(1).acc=stat_permutation_down_acc;
Results.Down.stats(2).auc=stat_permutation_down_auc;
Results.Time=time_sec; %this is for plotting later
