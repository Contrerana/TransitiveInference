function T2=SIassociation(ID,FilesPath,H)
folder=[FilesPath ID '/' ID '_S_I_Testing'];
List=dir(fullfile(folder,'*.mat')); % shouldbe 3 sessions, some participants only 2
no_sessions=numel(List);
T2=table();
for s=1:no_sessions
    load([folder '/' List(s).name]); %ResultsT struct: 2 blocks x 54 trials
    % find out session
    Session=extractBetween(List(s).name,'Session_','_.mat');Session=str2num(Session{1});
    T=table(); %to save the info
    for block=1:size(ResultsT,2)
        temp=table();
        % participant name
        PartID=cell(numel([ResultsT(block).Block.correctAns]),1);
        PartID(:)={ID};temp.ID=PartID;
        % relevant info
        temp.Answers=[ResultsT(block).Block.correctAns]'; %1 is right 0 mistake
        temp.RT=[ResultsT(block).Block.RT]';
        im={ResultsT(block).Block.image};
        % find category and condition
        id_F=contains(im,'face');id_O=contains(im,'objc');id_S=contains(im,'scen');
        category=cell(numel(im),1);condition=cell(numel(im),1);
        category(id_F)={'F'};category(id_O)={'O'};category(id_S)={'S'};
        condition(id_F)={H(strcmp([H.Category],'F')).Condition};
        condition(id_O)={H(strcmp([H.Category],'O')).Condition};
        condition(id_S)={H(strcmp([H.Category],'S')).Condition};
        temp.category=category;temp.condition=condition;
        % block number
        bl=block*ones(numel(im),1);
        temp.block=bl;
        % update table
        T=[T;temp];
    end
    session=Session*ones(size(T,1),1);
    T.session=session;
    T2=[T2;T];
end
end


    