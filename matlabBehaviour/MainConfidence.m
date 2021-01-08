%% find out about confident in answers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Same than before but now adding the score of how confident participants
% were in a scale from -1 to 1
% (c) Lorena Santamaria 06/01/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preparing
FilesPath='E:/Cardiff/CL_TMR/Sleep_CL_TMR/Participants/';
SavingPath='C:\Users\sapls6\Documents\MATLAB\TransitiveInference_Dec2020\csvBehFiles\';
GoodPart=[2,3,5,6,8,10:12,14:17,19,21:23,26:29]; %List of participants that received enough TMR
% load the PreExp list with the info for each participant of the Up/Down
% and hierarchy order and so on. It is a struct. 
load('C:\Users\sapls6\Documents\MATLAB\TransitiveInference_Dec2020\matlabBehaviour\CounterBalance.mat');
% saving data
Ses2=table();Ses3=table();
for pt=1:numel(GoodPart)
    disp(['Participant: ' num2str(GoodPart(pt))]);
    % Participant ID
    ID=['Participant_' num2str(GoodPart(pt))];
    % find out the elements of the hierarchy 
    H=Hierarchy(ID,FilesPath);
    %Find the order (F-O-S) 
    id=[PreExp.Number]==GoodPart(pt);
    H(1).Category=PreExp(id).H_first;
    H(2).Category=PreExp(id).H_second;
    H(3).Category=PreExp(id).H_nonCued;
    % Find wich one is UP/Down/Control
    if strcmp(PreExp(id).StartStage,'U')
        H(1).Condition='U'; H(2).Condition='D';
    elseif strcmp(PreExp(id).StartStage,'D')
        H(1).Condition='D'; H(2).Condition='U';
    end
    H(3).Condition='C';   
    %% Session 2
    Ses2=[Ses2;LateTestConfidence(ID,FilesPath,H,2)];
%     writetable(Ses2,[SavingPath 'CL_TMR_Late_Session2_ConfidentIntervals.csv']);
    disp('Late2 test done');
    %% Session 3    
    if pt<18
        % last 3 participants couldn't make because lockdown
        Ses3=[Ses3;LateTestConfidence(ID,FilesPath,H,3)];
%         writetable(Ses3,[SavingPath 'CL_TMR_Late_Session3_ConfidentIntervals.csv']);
        disp('Late3 test done');
    end
end