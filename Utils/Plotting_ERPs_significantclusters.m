%% Plotting stats results
% in GA_ERP we have the individual averages for the 4 conditions
% in GA_ERP2 we have the GA for the 4 conditions
% for plotting the results we calculate differences between them plus the
% interaction difference
% Lorena Santamaria 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg_diff=[];cfg_diff.operation='subtract';cfg_diff.parameter='avg';
GA_Exp_UPvsDOWN=ft_math(cfg_diff,GA_ERP1.up_exp,GA_ERP1.down_exp);% Experimental sounds: Up vs Down
GA_Cont_UPvsDOWN=ft_math(cfg_diff,GA_ERP1.up_cont,GA_ERP1.down_cont);% Control sounds: Up vs Down
GA_Up_EXPvsCONT=ft_math(cfg_diff,GA_ERP1.up_exp,GA_ERP1.up_cont);% Up condition: Exp vs Cont
GA_Down_EXPvsCONT=ft_math(cfg_diff,GA_ERP1.down_exp,GA_ERP1.down_cont);% Down condition: Exp vs Cont
GA_Diff_UPvsDOWN=ft_math(cfg_diff,ft_timelockgrandaverage(cfg_ERP1,Up_Diff{:}),ft_timelockgrandaverage(cfg_ERP1,Down_Diff{:}));% Diff exp-cont Up vs Down conditions
% define parameters for plotting (if there is anything to plot...)
timeStep=0.200;
SavingFigPath=[pwd 'ERP_figures/'];
plotting_significant_cluster_ERP (GA_Exp_UPvsDOWN,stat_Exp_up_down,500,lay,timeStep,[SavingFigPath 'Exp_UPvsDOWN'])
plotting_significant_cluster_ERP (GA_Cont_UPvsDOWN,stat_Cont_up_down,500,lay,timeStep,[SavingFigPath 'Cont_UPvsDOWN'])
plotting_significant_cluster_ERP (GA_Up_EXPvsCONT,stat_Up_exp_cont,500,lay,timeStep,[SavingFigPath 'Up_ExpVSControl']); 
plotting_significant_cluster_ERP (GA_Down_EXPvsCONT,stat_Down_exp_cont,500,lay,timeStep,[SavingFigPath 'Down_ExpVSControl']);
plotting_significant_cluster_ERP(GA_Diff_UPvsDOWN,stats_Up_Down_Diff,500,lay,timeStep,[SavingFigPath 'Up_Down_Diff']);