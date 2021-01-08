function T=IdentifyAllPairs(ID,Horder,PicsNo,H,Answers,RT,Session,block)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function associate to each trial the correct Pair
% Inputs:
%    Horder is the hierarchy numbers in the rigth order
%    PicNo is the pairs of pic shown in each trial
%    H is the info of which category and condition 
%    Answers is binary (1 is the press the right key, 0 otherwise)
%    RT; reaction times from stimuli onset to key pressed
%    Session: 1, 2 or 3
%    Block: block number 
% Outputs:
%    Pair: %AB, BC ...
%    Category: % Faces, Objects, Scenes
%    Condition: %Up/Down
% Lorena Santamaria (c) 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preprare things
P={'AB','BC', 'CD', 'DE','EF','BD','CE','BE','AF'};
PairType={'Premise','Premise','Premise','Premise','Premise',...
    'Inference','Inference','Inference','Anchor'};
Distance=[zeros(1,5),1,1,2,3];
T=struct();cont=1;
% Do the magic
for h=1:size(H,2)
    A=Horder((h*6)-5:h*6);% find out the order of the elements within the hierarchy
    A1=[A(1:5) A(2:3) A(2) A(1);A(2:6) A(4:5) A(5:6)];% put the hierarchy in pairs
    A2=[A1(2,:);A1(1,:)]; % the same but inverted as we show them A-B and B-A
    for pair=1:length(A1)
        T(cont).ID=ID;
        temp1=A1(:,pair);temp2=A2(:,pair);
        id=PicsNo==temp1' | PicsNo==temp2';id=sum(id,2)==2; %both elements of the pair
        T(cont).acc=mean(Answers(id));% to have more consistent results we avergaged both locations AB and BA
        % for the RT we consider as a whole but also separated in
        % hits/fails
        T(cont).RT=mean(RT(id));
        if T(cont).acc==1
            T(cont).RT_hits=mean(RT(id));T(cont).RT_fails=0; %both right
        elseif T(cont).acc==0
            T(cont).RT_fails=mean(RT(id));T(cont).RT_hits=0; %both wrong
        else
            anns=Answers(id);anssRT=RT(id);
            if sum(anns==[1;0])==2
                T(cont).RT_hits=anssRT(1);T(cont).RT_fails=anssRT(2); %one of each
            elseif sum(anns==[0;1])==2
                T(cont).RT_hits=anssRT(2);T(cont).RT_fails=anssRT(1); %one of each
            end
        end
        T(cont).Pair=P(pair); % identify the pair
        % find out the category
        if temp1(1)<=6
            % first category
            T(cont).category=H(1).Category;T(cont).condition={H(1).Condition};
        elseif temp1(1)>6 && temp1(1)<=12
            T(cont).category=H(2).Category;T(cont).condition={H(2).Condition}; %second
        elseif temp1(1)>12 && temp1(1)<=18
            T(cont).category=H(3).Category;T(cont).condition={H(3).Condition}; %third
        end
        % add stuff to be compatible for the session 2 with the inferences
        % and anchor pairs things
        T(cont).session=Session;T(cont).PairType=PairType(pair);
        T(cont).Distance=Distance(pair);T(cont).Block=block;
        cont=cont+1;
    end
end

    
