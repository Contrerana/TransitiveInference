%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRANSITIVE INFERENCE: PILOT DATA
%  Two groups of participants:
%    wake:  ~9am (session1) ~9pm (session2)
%    sleep: ~9pm (session1) ~9am (session2)
% Within each group two conditions:
%    all: premise and inference pairs presented in session1
%    prem: only premise pairs presented in session1
%    session2 is the same for everybody
% Lorena Santamaria (c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set-ups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fpath='D:\Pilot_InferenceLearning'; % where the wake-sleep files are
% if they see all pairs (0) or just premises (1) in the first session
condition=load(fullfile(Fpath,'SessionFiles'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Identify things and get the necessary files for stats
%  pair (premise/inference/anchor)
%  group (wake/sleep)
%  condition (all, prem)
%  distance (premises:0, inferences: 1 or 2, anchor:3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% wake group
cW=condition.sessionW; % length is no participants 
% find the participant folders
Wfiles=dir(fullfile(Fpath,'Wake'));
Wfiles(1:2,:)=[];Wfiles={Wfiles.name}';
% now tyde them up in numerical not alphabetical order
no=cellfun(@(x) str2num(x),extractAfter(Wfiles,'Participant_'));
[~,I]=sort(no);
Wfiles2=Wfiles(I);clear('I','no','Wfiles');
% loop accros participants
Twake=table();Tlearn=table();
for pt=1:numel(cW)
    % participant folder
    folder=fullfile(Fpath,'Wake',Wfiles2{pt});
    % extract info and concatenate it to the main
    if cW(pt)==1
        Tl=NoBlocksLearn(folder,'wake',Wfiles2{pt},'pre');
        folder1=[folder '\' Wfiles2{pt} '_Immediate'];
        s1=resultsInmediate(folder1,'wake',Wfiles2{pt},'pre');
        folder2=[folder '\' Wfiles2{pt} '_Late'];
        s2=resultsLate(folder2,'wake',Wfiles2{pt},'pre');
        s=[s1;s2];clear('s1','s2');
    else
        folder2=[folder '\' Wfiles2{pt} '_Late'];
        Tl=NoBlocksLearn(folder,'wake',Wfiles2{pt},'all');
        s=resultsLate(folder2,'wake',Wfiles2{pt},'all');
    end
    fprintf('Participant %d done, length table: %d \n',pt,size(s,1));
    Twake=[Twake;s];Tlearn=[Tlearn;Tl];
    clear('folder2','folder1','s','folder');
end
clear('cW','pt','Wfiles2');
%% sleep group
cS=condition.sessionS; % length is no participants 
% find the participant folders
Sfiles=dir(fullfile(Fpath,'Sleep'));
Sfiles(1:2,:)=[];Sfiles={Sfiles.name}';
% now tyde them up in numerical not alphabetical order
no=cellfun(@(x) str2num(x),extractAfter(Sfiles,'Participant_'));
[~,I]=sort(no);
Sfiles2=Sfiles(I);clear('I','no','Sfiles');
% loop accros participants
Tsleep=table();
for pt=1:numel(cS)
    % participant folder
    folder=fullfile(Fpath,'Sleep',Sfiles2{pt});
    % extract info and concatenate it to the main
    if cS(pt)==1
        Tl=NoBlocksLearn(folder,'sleep',Sfiles2{pt},'pre');
        folder1=[folder '\' Sfiles2{pt} '_Immediate'];
        s1=resultsInmediate(folder1,'sleep',Sfiles2{pt},'pre');
        folder2=[folder '\' Sfiles2{pt} '_Late'];
        s2=resultsLate(folder2,'sleep',Sfiles2{pt},'pre');
        s=[s1;s2];clear('s1','s2');
    else
        folder2=[folder '\' Sfiles2{pt} '_Late'];
        s=resultsLate(folder2,'sleep',Sfiles2{pt},'all');
        Tl=NoBlocksLearn(folder,'sleep',Sfiles2{pt},'all');
    end
    fprintf('Participant %d done, length table: %d \n',pt,size(s,1));
    Tsleep=[Tsleep;s];Tlearn=[Tlearn;Tl];
    clear('folder2','folder1','s','folder');
end
clear('cS','pt','Sfiles2');
%% join sleep and wake results and save it
T=[Tsleep;Twake];
writetable(T,fullfile(Fpath, 'Behavioural_csv_files','Total_Beh.csv'));
%% save the number of blocks to learn too
writetable(Tlearn,fullfile(Fpath, 'Behavioural_csv_files','BlocksToLearn.csv'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepare for JASP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% divide by type of pair and session and condition
id_pre=strcmp(T.PairType,'Premise');
id_inf=strcmp(T.PairType,'Inference');
id_anc=strcmp(T.PairType,'Anchor');

id_s1=strcmp(T.session,'S1');
id_s2=strcmp(T.session,'S2');

id_all=strcmp(T.Condition,'all');
id_p=strcmp(T.Condition,'pre');

% change names for session 1 and session 2
ColNames=T.Properties.VariableNames;
S1Names=append(ColNames,'_S1');
S2Names=append(ColNames,'_S2');

% premise pair 
T_premises_S1_pre=T(id_pre & id_s1 & id_p,:); % session 1 condition premises only
T_premises_S1_pre.Properties.VariableNames=S1Names;
T_premises_S2_pre=T(id_pre & id_s2 & id_p,:); % session 2 condition premises only
T_premises_S2_pre.Properties.VariableNames=S2Names;

T_premises_pre=[T_premises_S1_pre,T_premises_S2_pre];
writetable(T_premises_pre,fullfile(Fpath, 'Behavioural_csv_files','T_premises_pre.csv'));

T_premises_S1_all=T(id_pre & id_s1 & id_all,:); % session 1 condition all pairs
T_premises_S1_all.Properties.VariableNames=S1Names;
T_premises_S2_all=T(id_pre & id_s2 & id_all,:); % session 2 condition all pairs
T_premises_S2_all.Properties.VariableNames=S2Names;
% S2 has some fewer rows as e.g. P9 did only 2 blocks
Ttemp=T_premises_S2_all(1:60,:);
Ttemp(:,[1:3,6:9])={''};Ttemp(:,[4:5,10:11])={NaN};
T_premises_S2_all=[T_premises_S2_all;Ttemp];
T_premises_all=[T_premises_S1_all,T_premises_S2_all];
writetable(T_premises_all,fullfile(Fpath, 'Behavioural_csv_files','T_premises_all.csv'));

% inferences pair 
T_inferences_S2_pre=T(id_inf & id_s2 & id_p,:); % session 2  condition premises only
writetable(T_inferences_S2_pre,fullfile(Fpath, 'Behavioural_csv_files','T_inferences_pre.csv'));


T_inferences_S1_all=T(id_inf & id_s1 & id_all,:); % session 1 condition all pairs
T_inferences_S1_all.Properties.VariableNames=S1Names;
T_inferences_S2_all=T(id_inf & id_s2 & id_all,:); % session 2 condition all pairs
T_inferences_S2_all.Properties.VariableNames=S2Names;
% S2 has some fewer rows as e.g. P9 did only 2 blocks
Ttemp=T_inferences_S2_all(1:36,:);
Ttemp(:,[1:3,6:9])={''};Ttemp(:,[4:5,10:11])={NaN};
T_inferences_S2_all=[T_inferences_S2_all;Ttemp];
T_inferences_all=[T_inferences_S1_all,T_inferences_S2_all];
writetable(T_inferences_all,fullfile(Fpath, 'Behavioural_csv_files','T_inferences_all.csv'));

% anchor pair 
T_anchor_S2_pre=T(id_anc & id_s2 & id_p,:); % session 2  condition premises only
writetable(T_anchor_S2_pre,fullfile(Fpath, 'Behavioural_csv_files','T_anchor_pre.csv'));

T_anchor_S1_all=T(id_anc & id_s1 & id_all,:); % session 1 condition all pairs
T_anchor_S1_all.Properties.VariableNames=S1Names;
T_anchor_S2_all=T(id_anc & id_s2 & id_all,:); % session 2 condition all pairs
T_anchor_S2_all.Properties.VariableNames=S2Names;

% S2 has some fewer rows as e.g. P9 did only 2 blocks
Ttemp=T_anchor_S2_all(1:12,:);
Ttemp(:,[1:3,6:9])={''};Ttemp(:,[4:5,10:11])={NaN};
T_anchor_S2_all=[T_anchor_S2_all;Ttemp];
T_anchor_all=[T_anchor_S1_all,T_anchor_S2_all];
writetable(T_anchor_all,fullfile(Fpath, 'Behavioural_csv_files','T_anchor_all.csv'));


