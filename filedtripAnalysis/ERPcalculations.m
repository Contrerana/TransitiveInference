%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ERP analysis
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
for pt=1:numel(List)
     % baseline correction for ERP analysis
    cfg_bs=[];
    cfg_bs.baselinewindow=[-1 0];
    cfg_bs.inputfile=List{pt};
    dat_bc=ft_preprocessing(cfg_bs);
    % divide into conditions (1=up_exp 2=up_cont 3=down_exp 4=dwn=cont)
    cfg1=[];cfg1.trials=find(cell2mat(dat_bc.trialinfo)==1);cfg1.channel='all'; 
    cfg1.outputfile=[SavingPath 'ERP_' EEG1.setname '_up_exp.mat'];
    up_exp=ft_timelockanalysis(cfg1,dat_bc);
    cfg1=[];cfg1.trials=find(cell2mat(dat_bc.trialinfo)==2);
    cfg1.outputfile=[SavingPath 'ERP_' EEG1.setname '_up_cont.mat'];
    up_cont=ft_timelockanalysis(cfg1,dat_bc);
    cfg1=[];cfg1.trials=find(cell2mat(dat_bc.trialinfo)==3);
    cfg1.outputfile=[SavingPath 'ERP_' EEG1.setname '_down_exp.mat'];
    down_exp=ft_timelockanalysis(cfg1,dat_bc);
    cfg1=[];cfg1.trials=find(cell2mat(dat_bc.trialinfo)==4);
    cfg1.outputfile=[SavingPath 'ERP_' EEG1.setname '_down_cont.mat'];
    down_cont=ft_timelockanalysis(cfg1,dat_bc);
    % plot single subject avgs (to check)
    %cfg_plot=[];cfg_plot.layout=lay;
    %cfg_plot.interactive='yes';cfg_plot.showoutline='yes';
    %ft_multiplotER(cfg_plot,up_exp,up_cont,down_exp,down_cont);
end
%% Gran Average ERP's 
cfg_ERP=[];
cfg_ERP.keepindividual='yes';cfg_ERP.normalizevar='N';
cfg_ERP.channel=lay.label(1:60);cfg_ERP.latency='all';cfg_ERP.parameter='avg';
cond_name={'up_cont','up_exp','down_cont','down_exp'};

cfg_ERP1=[];
cfg_ERP1.keepindividual='no';cfg_ERP1.normalizevar='N';
cfg_ERP1.channel=lay.label(1:60);cfg_ERP1.latency='all';cfg_ERP1.parameter='avg';

for cond=1:numel(cond_name)
    GA=cell(1,numel(List)); %allocate memory
    condition=cond_name{cond};
    for s=1:numel(List)
        subject=extractBefore(List{s},'.set');
        data_in=load([SavingPath2 'ERP_' subject '_' condition '.mat']);
        GA{s}=data_in.timelock;
    end
    GA_ERP.(condition)=ft_timelockgrandaverage(cfg_ERP,GA{:}); 
    GA_ERP1.(condition)=ft_timelockgrandaverage(cfg_ERP1,GA{:}); 
    GA_all.(condition)=GA;
end
% save it
save('ERP_GranAvg_Allconditions.mat','GA_ERP');