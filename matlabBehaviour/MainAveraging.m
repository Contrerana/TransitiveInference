%% AVERAGE FOR EACH PARTICIPANT
% Average across trials for each participant so then we can use for
% correlation purposes. 
% Result it is storage in a csv file
% (c) Lorena Santamaria 08/01/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preparing
FilesPath='C:\Users\sapls6\Documents\MATLAB\TransitiveInference_Dec2020\csvBehFiles\';
GoodPart=[2,3,5,6,8,10:12,14:17,19,21:23,26:29]; %List of participants that received enough TMR
% load Premise files for each session
PremisesS1=readtable([FilesPath 'CL_TMR_Immediate.csv']);
PremisesS2=readtable([FilesPath 'CL_TMR_Premises_S2.csv']);
PremisesS3=readtable([FilesPath 'CL_TMR_Premises_S3.csv']);
% load Inference files for each session
InferenceS2=readtable([FilesPath 'CL_TMR_Inference_S2.csv']);
InferenceS3=readtable([FilesPath 'CL_TMR_Inference_S3.csv']);
% load anchor files for each session
AnchorS2=readtable([FilesPath 'CL_TMR_Anchor_S2.csv']);
AnchorS3=readtable([FilesPath 'CL_TMR_Anchor_S3.csv']);
%% averaging
AccAvg=struct();
for pt=1:numel(GoodPart)
    disp(['Participant: ' num2str(GoodPart(pt))]);
    % Participant ID
    ID=['Participant_' num2str(GoodPart(pt))];
    AccAvg(pt).ID=ID;
    % Premises pairs average S1
    Tpt=PremisesS1(strcmp(PremisesS1.ID,ID),:);
    PresS1=averages(Tpt,'Premise');
    AccAvg(pt).Premise_S1_U=PresS1(1);
    AccAvg(pt).Premise_S1_D=PresS1(2);
    AccAvg(pt).Premise_S1_C=PresS1(3);
    % Premises pairs average S2
    Tpt=PremisesS2(strcmp(PremisesS2.ID,ID),:);PresS2=averages(Tpt,'Premise');
    AccAvg(pt).Premise_S2_U=PresS2(1);
    AccAvg(pt).Premise_S2_D=PresS2(2);
    AccAvg(pt).Premise_S2_C=PresS2(3);
    % Premises pairs average S3
    Tpt=PremisesS3(strcmp(PremisesS3.ID,ID),:);PresS3=averages(Tpt,'Premise');
    AccAvg(pt).Premise_S3_U=PresS3(1);
    AccAvg(pt).Premise_S3_D=PresS3(2);
    AccAvg(pt).Premise_S3_C=PresS3(3);
    % Inference pairs average S2 without distance
    Tpt=InferenceS2(strcmp(InferenceS2.ID,ID),:);PresS2=averages(Tpt,'Inference');
    AccAvg(pt).Inference_S2_U=PresS2(1);
    AccAvg(pt).Inference_S2_D=PresS2(2);
    AccAvg(pt).Inference_S2_C=PresS2(3);
    % Inference pairs average S3 without distance
    Tpt=InferenceS3(strcmp(InferenceS3.ID,ID),:);PresS3=averages(Tpt,'Inference');
    AccAvg(pt).Inference_S3_U=PresS3(1);
    AccAvg(pt).Inference_S3_D=PresS3(2);
    AccAvg(pt).Inference_S3_C=PresS3(3);
    % Inference pairs average S2 wit distance
    Tpt=InferenceS2(strcmp(InferenceS2.ID,ID),:);[dist1,dist2]=averages(Tpt,'Distance');
    AccAvg(pt).Inference_S2_U_Dist1=dist1(1);AccAvg(pt).Inference_S2_U_Dist2=dist2(1);
    AccAvg(pt).Inference_S2_D_Dist1=dist1(2);AccAvg(pt).Inference_S2_D_Dist2=dist2(2);
    AccAvg(pt).Inference_S2_C_Dist1=dist1(3);AccAvg(pt).Inference_S2_C_Dist2=dist2(3);
    % Inference pairs average S3 without distance
    Tpt=InferenceS3(strcmp(InferenceS3.ID,ID),:);[dist1,dist2]=averages(Tpt,'Distance');
    AccAvg(pt).Inference_S3_U_Dist1=dist1(1);AccAvg(pt).Inference_S3_U_Dist2=dist2(1);
    AccAvg(pt).Inference_S3_D_Dist1=dist1(2);AccAvg(pt).Inference_S3_D_Dist2=dist2(2);
    AccAvg(pt).Inference_S3_C_Dist1=dist1(3);AccAvg(pt).Inference_S3_C_Dist2=dist2(3);
    % Anchor pairs average S2 
    Tpt=AnchorS2(strcmp(AnchorS2.ID,ID),:);PresS2=averages(Tpt,'Anchor');
    AccAvg(pt).Anchor_S2_U=PresS2(1);
    AccAvg(pt).Anchor_S2_D=PresS2(2);
    AccAvg(pt).Anchor_S2_C=PresS2(3);
    % Anchor pairs average S3 
    Tpt=AnchorS3(strcmp(AnchorS3.ID,ID),:);PresS2=averages(Tpt,'Anchor');
    AccAvg(pt).Anchor_S3_U=PresS3(1);
    AccAvg(pt).Anchor_S3_D=PresS3(2);
    AccAvg(pt).Anchor_S3_C=PresS3(3);
end
AccAvg=struct2table(AccAvg); 
%Note: there are NaNs value for those 3 participants didn't make it for the
%followup before lockdown
%% Save it
writetable(AccAvg,[FilesPath 'CL_TMR_Avg_AllPairticpants_AllPairType.csv']);
