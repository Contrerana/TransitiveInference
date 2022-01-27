function T=IdentifyAllPairs(ID,Horder,PicsNo,Img,Answers,RT,Session,block,group,cond)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function associate to each trial the correct Pair
% Inputs:
%    Horder is the hierarchy numbers in the rigth order
%    PicNo is the pairs of pic shown in each trial
%    Img is the info of which stimulus
%    Answers is binary (1 is the press the right key, 0 otherwise)
%    RT; reaction times from stimuli onset to key pressed
%    Session: 1, 2 or 3
%    Block: block number 
% Outputs:
%    Pair: %AB, BC ...
%    Category: % Faces, Objects, Scenes
% Lorena Santamaria (c) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preprare things
P={'AB','BC', 'CD', 'DE','EF','BD','CE','BE','AF'};
PairType={'Premise','Premise','Premise','Premise','Premise',...
    'Inference','Inference','Inference','Anchor'};
Distance=[zeros(1,5),1,1,2,3];
T=struct();cont=1;
% Do the magic
for h=1:3 % 3 hierarchies
    A=Horder((h*6)-5:h*6);% find out the order of the elements within the hierarchy
    A1=[A(1:5) A(2:3) A(2) A(1);A(2:6) A(4:5) A(5:6)];% put the hierarchy in pairs
    A2=[A1(2,:);A1(1,:)]; % the same but inverted as we show them A-B and B-A
    for pair=1:length(A1)
        T(cont).ID=[ID '_' group];T(cont+1).ID=[ID '_' group];
        T(cont).Group=group;T(cont+1).Group=group;
        T(cont).Condition=cond;T(cont+1).Condition=cond;
        temp1=A1(:,pair);temp2=A2(:,pair);
        id1=sum(PicsNo==temp1',2); %one position
        id2=sum(PicsNo==temp2',2);  % the other position
        T(cont).acc=Answers(id1==2);
        T(cont+1).acc=Answers(id2==2);
        % we add the reaction time
        T(cont).RT=RT(id1==2);
        T(cont+1).RT=RT(id2==2);
        % identify the pair
        T(cont).Pair=P(pair);
        T(cont+1).Pair=P(pair);
                % find out the category(O/F/S)
        if contains(Img(id1==2),'Object')
            T(cont).Stim='O';T(cont+1).Stim='O';
        elseif contains(Img(id1==2),'female')
            T(cont).Stim='F';T(cont+1).Stim='F';
        else
            T(cont).Stim='S';T(cont+1).Stim='S';
        end
        % add stuff to be compatible for the session 2 with the inferences
        % and anchor pairs things
        T(cont).session=Session;T(cont).PairType=PairType(pair);
        T(cont).Distance=Distance(pair);T(cont).Block=block;
        T(cont+1).session=Session;T(cont+1).PairType=PairType(pair);
        T(cont+1).Distance=Distance(pair);T(cont+1).Block=block;
        cont=cont+2;
    end
end