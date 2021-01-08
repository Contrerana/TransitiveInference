%% no of trials to learn
Learning = readtable('C:\Users\sapls6\Documents\MATLAB\TransitiveInference_Dec2020\csvBehFiles\CL_TMR_Learning.csv');
GoodPart=[2,3,5,6,8,10:12,14:17,19,21:23,26:29]; %List of participants that received enough TMR
%% find the acc of the middle pairs 
NoBlocks=struct();
for pt=1:numel(GoodPart)
    ID=['Participant_' num2str(GoodPart(pt))];
    NoBlocks(pt).ID=ID;
    id_pt=strcmp(Learning.ID,ID); %trials from our paticipant
    T=Learning(id_pt,:); %we make table smaller
    no_blocks=numel(unique([T.Block]));
    acc=struct();N=zeros(no_blocks,3);
    for b=1:no_blocks
        % per block we find the accuracy of BC,CD,DE of each category
        Tblock=T([T.Block]==b,:);Acc=Tblock.acc;
        id_pair=strcmp(Tblock.Pair,'BC') | strcmp(Tblock.Pair,'CD') | strcmp(Tblock.Pair,'DE');
        id_F=strcmp(Tblock.category,'F') & id_pair;acc(b).F=mean(Acc(id_F));
        id_S=strcmp(Tblock.category,'S')& id_pair;acc(b).S=mean(Acc(id_S));
        id_O=strcmp(Tblock.category,'O')& id_pair;acc(b).O=mean(Acc(id_O)); 
        if mean(Acc(id_F))>0.6,N(b,1)=1;end
        if mean(Acc(id_S))>0.6, N(b,2)=1;end
        if mean(Acc(id_O))>0.6, N(b,3)=1;end
    end
    [NoBlocks(pt).F,NoBlocks(pt).S,NoBlocks(pt).O]=FindNoBlocksToLearn(N);
end
%% save it
SavingPath='C:\Users\sapls6\Documents\MATLAB\TransitiveInference_Dec2020\csvBehFiles\';
writetable(struct2table(NoBlocks),[SavingPath 'CL_TMR_No_Trials_Criterio.csv']);

    