function H=Hierarchy(ID,FilesPath)
% ID is a string in the shape of 'Participant_<no>'
load([FilesPath '/' ID '/' ID '_Stimuli/' ID '_Stimuli.mat']);
H(1).exp=Stimuli(1).CuedID;H(1).ctr=Stimuli(1).ControlID;
H(2).exp=Stimuli(2).CuedID;H(2).ctr=Stimuli(2).ControlID;
H(3).exp=Stimuli(3).CuedID;H(3).ctr=Stimuli(3).ControlID;
end
