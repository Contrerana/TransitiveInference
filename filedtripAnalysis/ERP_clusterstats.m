%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ERP cluster stats
%
%
%
% Lorena Santamaria Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set-ups
%start fieltrip
run('/home/sapls6/Documents/MATLAB/Toolboxes/fieldtrip-20200310/ft_defaults.m');
% load the files
load('ERP_GranAvg_Allconditions.mat');
% load fieldtrip layout
load('EasyCapLayOut.mat');

%% define neighbours
cfg_ne=[];
cfg_ne.channel='all';
cfg_ne.method='triangulation';
cfg_ne.layout=lay;
cfg_ne.feedback='yes';
neighbours=ft_prepare_neighbours(cfg_ne,GA_ERP.up_cont);
%% prepare stats
cfg_test=[];
cfg_test.latency=[-1 2];
cfg_test.channel='all';
cfg_test.method='montecarlo';
cfg_test.statistic='depsamplesT';%withsubj design
cfg_test.correctm='cluster';
cfg_test.tail=0; %2 tailed test
cfg_test.clustertail=0; %2 tailed test
cfg_test.alpha=0.05; 
cfg_test.clusteralpha=0.025; %because two-tailed
cfg_test.minnbchan=2; %at least 2 ch to be a cluster
cfg_test.neighbours=neighbours;
cfg_test.numrandomization=10000; % the mroe the better
%% prepare design
cfg_test.uvar=1;
cfg_test.ivar=2;
no_sub=numel(GA_ERP.up_cont);
design=zeros(2,2*no_sub);
design(1,:)=[1:no_sub 1:no_sub];
design(2,:)=[ones(1,no_sub) 2*ones(1,no_sub)];
cfg_test.design=design;
%% ready to run stats
stat_Exp_up_down=ft_timelockstatistics(cfg_test,GA_all.up_exp{:},GA_all.down_exp{:});
stat_Cont_up_down=ft_timelockstatistics(cfg_test,GA_all.up_cont{:},GA_all.down_cont{:});
stat_Up_exp_cont=ft_timelockstatistics(cfg_test,GA_all.up_exp{:},GA_all.up_cont{:});
stat_Down_exp_cont=ft_timelockstatistics(cfg_test,GA_all.down_exp{:},GA_all.down_cont{:});
%% calculate the difference between exp and control sounds to do stats
cfg_diff=[];cfg_diff.operation='subtract';cfg_diff.parameter='avg';
Up_Diff=cell(1,numel(List)); %allocate memory
Down_Diff=cell(1,numel(List)); %allocate memory
for s=1:no_sub
    Up_Diff{s}=ft_math(cfg_diff,GA_all.up_exp{s},GA_all.up_cont{s});
    Down_Diff{s}=ft_math(cfg_diff,GA_all.down_exp{s},GA_all.down_cont{s});
end
%% re-peat the statss for the interaction effect (difference)
stats_Up_Down_Diff=ft_timelockstatistics(cfg_test,Up_Diff{:},Down_Diff{:}); 
%% save all the stats together
save(['ERP_All_Conditions_Stats.mat'],'stat_Exp_up_down','stat_Cont_up_down',...
    'stat_Up_exp_cont','stat_Down_exp_cont','stats_Up_Down_Diff');