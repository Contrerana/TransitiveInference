function T=NoBlocksLearn(folder,group,ID,cond)
% folder to the learning part
name=fullfile(folder,[ID '_Learning'],[ID '_Learning_Session_1.mat']);
load(name);
no_blocks=size(Result_Total,2);
id=['P' extractAfter(ID,'_') '_' group];
Res.ID={id};
Res.group={group};
Res.cond={cond};
Res.NoBlocks=no_blocks;
T=struct2table(Res);
