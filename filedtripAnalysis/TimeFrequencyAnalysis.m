%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Time-frequency analysis
%
%
%
% Lorena Santamaria Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set-ups
%start fieltrip
run('/home/sapls6/Documents/MATLAB/Toolboxes/fieldtrip-20200310/ft_defaults.m');
% set up files and files directories
FilesPath=''; %your path
List=dir(fullfile(FilesPath,'*.mat'));
List={List.name}'; % only their names are interesting
UpDown=readtable('List_UpDown.csv'); % S100's Up==1 
% load fieldtrip layout
load('EasyCapLayOut.mat');
%% for each participant calculate the averaged ERP per condition
TFR_all=struct(); %allocate memory
for pt=1:numel(List)
    % time frequency
    cfgTF=[];
    cfgTF.channel='all';
    cfgTF.method='wavelet';
    cfgTF.width=5;
    cfgTF.ouput='pow';
    cfgTF.foi=4:0.5:20;
    cfgTF.toi=0:0.010:2.5;
    % Up experiment
    cfgTF.inputfile=[SavingPath 'CleanReReferenced_' fname '_up_exp.mat'];
    TF_up_exp0=ft_freqanalysis(cfgTF);
    % Up control
    cfgTF.inputfile=[SavingPath 'CleanReReferenced_' fname '_up_cont.mat'];
    TF_up_cont0=ft_freqanalysis(cfgTF);
    % Down experiment
    cfgTF.inputfile=[SavingPath 'CleanReReferenced_' fname '_down_exp.mat'];
    TF_down_exp0=ft_freqanalysis(cfgTF);
    % Down control
    cfgTF.inputfile=[SavingPath 'CleanReReferenced_' fname '_down_cont.mat'];
    TF_down_cont0=ft_freqanalysis(cfgTF);

     % baseline normalization
     cfg_bs=[];cfg_bs.baseline=[-1 2.5]; % whole trial more stable results (Delourme)
     cfg_bs.baselinetype='relchange'; %'absloute','relative','relchange','normchange','db','vssum','zscore'
     TF_up_exp=ft_freqbaseline(cfg_bs,TF_up_exp0);
     TF_up_cont=ft_freqbaseline(cfg_bs,TF_up_cont0);
     TF_down_exp=ft_freqbaseline(cfg_bs,TF_down_exp0);
     TF_down_cont=ft_freqbaseline(cfg_bs,TF_down_cont0);
     % calculate differences between up and down
     cfg_diff=[];cfg_diff.operation='subtract';cfg_diff.parameter='powspctrm';
     Up_Diff=ft_math(cfg_diff,TF_up_exp,TF_up_cont);
     Down_Diff=ft_math(cfg_diff,TF_down_exp,TF_down_cont); 
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % plotting to check 
%      cfg_plot=[];cfg_plot.baseline='no'; cfg_plot.baselinetype='relative';
%      cfg_plot.marker='on';cfg_plot.layout=lay;
%      cfg_plot.interactive='no';cfg_plot.channel='F3';
%     figure;ft_singleplotTFR(cfg_plot,TF_up_exp);caxis([-2 2]);
%     figure;ft_singleplotTFR(cfg_plot,TF_up_cont);caxis([-2 2]);
%     figure;ft_singleplotTFR(cfg_plot,TF_down_exp);caxis([-2 2]);
%     figure;ft_singleplotTFR(cfg_plot,TF_down_cont);caxis([-2 2]);
%     figure;  ft_singleplotTFR(cfg_plot,Down_Diff);caxis([-2 2]);
%     figure;ft_singleplotTFR(cfg_plot,Up_Diff);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % storage them for later on
     TFR_all(pt).up_exp=TF_up_exp;
     TFR_all(pt).up_cont=TF_up_cont;
     TFR_all(pt).down_exp=TF_down_exp;
     TFR_all(pt).down_cont=TF_down_cont;
     TFR_all(pt).up_diff=Up_Diff;
     TFR_all(pt).down_diff=Down_Diff;
end
%% Calculate GA
cfgGA=[];
cfgGA.keepindividual='yes';cfgGA.parameter='powspctrm';
cfgGA.foilim='all';cfgGA.toilim='all';cfgGA.channel='all';
cond_name={'up_cont','up_exp','down_cont','down_exp','up_diff','down_diff'};
GA_TFR=struct();
for cond=1:numel(cond_name)
    condition=cond_name{cond};
    all={TFR_all.(condition)};
    % powsptrm will be a no_sub x no channles x no freq x no time points
    GA_TFR.(condition)=ft_freqgrandaverage(cfgGA,all{:}); % powspctrm
end
save('TFR_GranAvg_Allconditions.mat','GA_TFR');
%% Permutations: cluster based
% define neighbours
cfg_ne=[];
cfg_ne.channel='all';
cfg_ne.method='triangulation';
cfg_ne.layout=lay;
cfg_ne.feedback='no';
neighbours=ft_prepare_neighbours(cfg_ne,GA_TFR.up_cont);
% prepare stats
cfg_test=[];
cfg_test.channel='all';
cfg_test.latency=[0 2.5];
cfg_test.method='montecarlo';
cfg_test.statistic='ft_statfun_depsamplesT';%withsubj design
cfg_test.correctm='cluster';
% % % % % % % % cfg_test.tail=0; %2 tailed test
cfg_test.tail=-1; %right tail only
% % % % % % cfg_test.clustertail=0; %2 tailed test
cfg_test.clustertail=cfg_test.tail;
cfg_test.alpha=0.05; 
cfg_test.clusteralpha=0.05; % cos it's 1tailed, otherwise 0.05 like the ERPs
cfg_test.minnbchan=0; 
cfg_test.neighbours=neighbours;
cfg_test.numrandomization=10000;
% prepare design
cfg_test.uvar=1;
cfg_test.ivar=2;
no_sub=size(GA_TFR.down_diff.powspctrm,1);
design=zeros(2,2*no_sub);
design(1,:)=[1:no_sub 1:no_sub];
design(2,:)=[ones(1,no_sub) 2*ones(1,no_sub)];
cfg_test.design=design;
% ready to run stats
stat_Exp_up_down=ft_freqstatistics(cfg_test,[GA_TFR.up_exp],[GA_TFR.down_exp]);
stat_Cont_up_down=ft_freqstatistics(cfg_test,[GA_TFR.up_cont],[GA_TFR.down_cont]);
stat_Up_exp_cont=ft_freqstatistics(cfg_test,[GA_TFR.up_exp],[GA_TFR.up_cont]);
stat_Down_exp_cont=ft_freqstatistics(cfg_test,[GA_TFR.down_exp],[GA_TFR.down_cont]);
stats_Up_Down_Diff=ft_freqstatistics(cfg_test,[GA_TFR.up_diff],[GA_TFR.down_diff]);