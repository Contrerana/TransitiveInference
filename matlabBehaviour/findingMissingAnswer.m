function Result=findingMissingAnswer (Result)
Keycorrect=[Result.CorrectKey]';
Keypressed={Result.response}';
KeyNumber={Result.responsenumber}';
[~,nc]=cellfun(@size,KeyNumber);
 id_c=nc~=1;
 if sum(id_c)~=0
      % It can be that the answer register 2 keypressed
     Key=KeyNumber(id_c);Key=Key{1};Key=Key(2);
     Good=Keycorrect(id_c);
     if Key==Good
         Result(id_c).correctAns=1;
     else
         Result(id_c).correctAns=1;
     end
 end
