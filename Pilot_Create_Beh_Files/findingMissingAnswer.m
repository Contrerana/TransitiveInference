function Result=findingMissingAnswer (Result)
% This function try to find why the number of answers differs from the
% other parameters on the same block
% Inputs:
%    Result: struct with the problem
% Outputs:
%   Result: struct with the problem fixed
% Lorena Santamaria (c) 2020
Keycorrect=[Result.CorrectKey]';
Keypressed={Result.response}';
KeyNumber={Result.responsenumber}';
[~,nc]=cellfun(@size,KeyNumber);
 id_c=nc~=1;
 if sum(id_c)~=0
      % It can be that the answer register 2 keypressed
     Key=KeyNumber(id_c);
     Good=Keycorrect(id_c);
     for ii=1:size(Key,1)
         temp=Key{ii,1};temp=temp(1); %choose first answer
         if Good(ii)==temp
             Result(id_c).correctAns=1;
         else
             Result(id_c).correctAns=1;
         end             
     end        
 end
