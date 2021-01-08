function NoBlocks=FindNoBlocksToLearn(N)
% N: no_blocks by 3 (F-S-O) with 1s if acc>0.66 and 0s otherwise
% (c) Lorena Santamaria 06/01/2021
NoBlocks.F=aux(N(:,1));
NoBlocks.S=aux(N(:,2));
NoBlocks.O=aux(N(:,3));

end
function NoB=aux(N1)
no_blocks=numel(N1);
for b=3:no_blocks
    if N1(b-2)==1 && N1(b-1)==1
        NoB=b-1;
    end
    if (N1(b)==1 && N1(b-1)==1) || (N1(b,1)==1 && N1(b-2)==1)
        NoB=b;
    end
end
end