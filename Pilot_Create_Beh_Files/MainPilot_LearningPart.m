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
%% Identify things and get the necessary files for learning part 
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
Twake=table();
for pt=1:numel(cW)
    % participant folder
    folder=fullfile(Fpath,'Wake',Wfiles2{pt});
    if cW(pt)==1
        T=resultsLearning(folder,'Wake',Wfiles2{pt},'pre');
    else
        T=resultsLearning(folder,'Wake',Wfiles2{pt},'all');
    end
    fprintf('Participant %d done, length table: %d \n',pt,size(T,1));
    Twake=[Twake;T];
    clear('folder','T');
end 
%% sleep group
cS=condition.sessionS; % length is no participants 
cS(3:4,:)=[];
% find the participant folders
Sfiles=dir(fullfile(Fpath,'Sleep'));
Sfiles(1:2,:)=[];Sfiles={Sfiles.name}';
% now tyde them up in numerical not alphabetical order
no=cellfun(@(x) str2num(x),extractAfter(Sfiles,'Participant_'));
[~,I]=sort(no);
Sfiles2=Sfiles(I);clear('I','no','Sfiles');
Sfiles2(3:4,:)=[];
% loop accros participants
Tsleep=table();
for pt=1:numel(cS)
    % participant folder
    folder=fullfile(Fpath,'Sleep',Sfiles2{pt});
    if cW(pt)==1
        T=resultsLearning(folder,'sleep',Sfiles2{pt},'pre');
    else
        T=resultsLearning(folder,'sleep',Sfiles2{pt},'all');
    end
    fprintf('Participant %d done, length table: %d \n',pt,size(T,1));
    Tsleep=[Tsleep;T];
    clear('folder','T');
end 
clear('cS','pt','Sfiles2','Wfiles2');
%% join sleep and wake results and save it
T=[Tsleep;Twake];
writetable(T,fullfile(Fpath, 'Behavioural_csv_files','Learning_Beh2.csv'),'Delimiter',',');
% english excell ','
% spanish excell ';'
