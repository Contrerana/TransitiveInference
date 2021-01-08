function [out,out2]=averages(Tpt,Type)
% average across trials for each condition for correlations
% we dont have pairinformation any more
% (c) Lorena Santamaria 08/01/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% allocate
out=zeros(3,1);out2=zeros(3,1);% 3 conditions
% do the important things
switch Type
    case 'Premise'
        id_up=strcmp(Tpt.condition,'U');
        id_down=strcmp(Tpt.condition,'D');
        id_c=strcmp(Tpt.condition,'C');
        U=mean(Tpt.acc(id_up));
        D=mean(Tpt.acc(id_down));
        C=mean(Tpt.acc(id_c));
        out=[U,D,C];
    case 'Inference'
        id_up=strcmp(Tpt.condition,'U');
        id_down=strcmp(Tpt.condition,'D');
        id_c=strcmp(Tpt.condition,'C');
        U=mean(Tpt.acc(id_up));
        D=mean(Tpt.acc(id_down));
        C=mean(Tpt.acc(id_c));
        out=[U,D,C];
    case 'Distance'
        id_up=strcmp(Tpt.condition,'U');
        id_down=strcmp(Tpt.condition,'D');
        id_c=strcmp(Tpt.condition,'C');
        id_1=[Tpt.Distance]==1;
        id_2=[Tpt.Distance]==2;
        U1=mean(Tpt.acc(id_up & id_1));
        D1=mean(Tpt.acc(id_down & id_1));
        C1=mean(Tpt.acc(id_c & id_1));
        U2=mean(Tpt.acc(id_up & id_2));
        D2=mean(Tpt.acc(id_down & id_2));
        C2=mean(Tpt.acc(id_c & id_2));
        out=[U1,D1,C1];out2=[U2,D2,C2];
    case 'Anchor'
        id_up=strcmp(Tpt.condition,'U');
        id_down=strcmp(Tpt.condition,'D');
        id_c=strcmp(Tpt.condition,'C');
        U=mean(Tpt.acc(id_up));
        D=mean(Tpt.acc(id_down));
        C=mean(Tpt.acc(id_c));
        out=[U,D,C];
    otherwise
        disp('Error: try harder')
end
