function events=AddingConditionToEvents(events,flag)
% Inputs:
%   events: EEG triggers
%   flag if 1 --> Up(S100s)  and if =2 then is Down (S1toS50)
%
% Output:
%   events:updated events struct with the field condition added
%
% Lorena Santamaria Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
condition=zeros(numel(events),1);
if isfield(events,'value')
    triggers={events.value};
elseif isfield(events,'type')
    triggers={events.type};
end
triggers=str2double(extractAfter(triggers,'S'));
if flag==1
    id_up_exp=triggers>=100 & triggers<=112;
    id_up_cont=triggers>112;
    id_down_exp=triggers>=1 & triggers<=12;
    id_down_cont=triggers>12 & triggers<100;
elseif flag==2
    id_down_exp=triggers>=100 & triggers<=112;
    id_down_cont=triggers>112;
    id_up_exp=triggers>=1 & triggers<=12;
    id_up_cont=triggers>12 & triggers<100;
end
% create the condition field 
condition(id_up_exp)=1;
condition(id_up_cont)=2;
condition(id_down_exp)=3;
condition(id_down_cont)=4;
% add it to events
C=num2cell(condition);
[events(1:length(condition)).Condition]=C{:};
