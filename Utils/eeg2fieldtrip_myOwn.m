function eeg2fieldtrip_myOwn(fname,FilesPath,UpDown, SavePath)
% Inputs:
%   fname: eeglab format file name
%   FilesPath: where the eeglab files are 
%   SavingPath: where the fieldtrip files will be
%   UpDown: table with the condition info (Up/Down Exp/Ctrol sounds)
%   SavePath: path were the new files will be saved for posterior analysis
% Output:
%   No outputs, the re-referenced fieldtrip format is save in SavePath
%
% Lorena Santamaria Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Change from eeglab to fieldtrip
% Read the .set file (eeglab format)
EEG1=pop_loadset(fname,FilesPath);
% start the process to pass it to fieldtrip
hdr= ft_read_header([FilesPath '/' fname]);
data   = ft_read_data([FilesPath '/' fname], 'header', hdr );
events = ft_read_event([FilesPath '/' fname], 'header', hdr );
events(strcmp({events.type},'trial'))=[];
% check events and data are the same size
if numel(events)~=size(data,3)
    % error
    warndlg('Error tr');return;
end
% add to events condition (Up/Down and Exp/Cont)
id=UpDown(strcmp(UpDown.ID,extractBefore(fname,'Sleep')),2);id=id.S100;
flag=0;
if strcmp(id,'U')
    flag=1;
elseif strcmp(id,'D')
    flag=2;
end
events=AddingConditionToEvents(events,flag);
% passing it to fieldtrip
datt=struct();
datt.hdr=hdr;datt.fsample=EEG1.srate;
%fn = intersect(fieldnames(events), {'value','sample','Condition'});
datt.trialinfo = cell(numel(events),1);
for tr=1:size(data,3)
    datt.trial(tr)={squeeze(data(:,:,tr))};
    datt.time(tr)={EEG1.times./1000};
    % % % % % % %         s =struct();
    % % % % % % %         for ff=1:numel(fn)
    % % % % % % %             s.(fn{ff}) = events(tr).(fn{ff});
    % % % % % % %             if iscell(s.(fn{ff}))
    % % % % % % %                 s.(fn{ff}) = s.(fn{ff}){1};
    % % % % % % %             end
    % % % % % % %         end
    % % % % % % %         datt.trialinfo{tr} = s;
end
datt.label={EEG1.chanlocs.labels}';
datt.trialinfo={events.Condition}';
datt.cfg.method='trial';
datt.cfg.checkpath='pedantic';
datt.dimord = 'rpt_chan_time';
% now we can read it in ft and re-reference it to mastoids (~ish)
cfg_pre=[];
cfg_pre.reref='yes';cfg_pre.refchannel={'TP9','TP10'};
a=extractBetween(fname,'P','Sleep');% we extract the participant number
cfg_pre.outputfile=fullfile(SavePath,['sub' sprintf('%0.3d',a{1})]);
dat= ft_preprocessing(cfg_pre, datt);

