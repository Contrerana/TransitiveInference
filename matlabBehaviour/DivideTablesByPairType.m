%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Change csv files into Premises/Inference/Anchor pairs individual files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we have done inthe Main part a division by sessions, now we do by type of
% pairs as it is how will be analysed: Premises, Inferences and Anchors
% (c) Lorena Santamaria 06/01/2021

%% PREMISES PAIRS
% we have info from the 3 sessions
% session1: Inmediate
% session 2: Ses2
% session 3: Ses3
% get the premises pairs info from Ses2 and Ses3
id2=strcmp(Ses2.PairType,'Premise');
Premises2=Ses2(id2,:);
id3=strcmp(Ses3.PairType,'Premise');
Premises3=Ses3(id3,:); %smaller as not all did session3
% join the 3 tables
Premises=[Inmediate;Premises2;Premises3];