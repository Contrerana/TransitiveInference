function Scores=TransformHypnofile(hip,NoTotalSamples,fs)
% hip is the hypnofile with the scorings from Miguel's toolbox (https://github.com/mnavarretem/psgScore)
% scores are done in 30s intervals
% values of the hypnofile
    % 0: awake
    % 1 to 3: N1, N2 and N3
    % 4: arousals/artifacts
    % 5: REM
% Scores in the transformation of the 30s epoch scoring into a score for
% each time sample of the recording
    scores=hip.dat(1,:); %the other two are the classifiers scores.
    arousals=hip.arousals{1,1}; %the other two are the classifiers scores.  
    arousals2=arousals(:,1)./30;% pass arousals from seconds to epoch number
    interval=30*fs; %30second epochs at 500Hz
    Scores=zeros(NoTotalSamples,1); %pre-allocate memory
    for ss=1:numel(scores)
        if sum(arousals2==ss)==0%check if that interval is an arousal
             Scores(1+(ss-1)*interval:ss*interval)=scores(ss);
        else
            Scores(1+(ss-1)*interval:ss*interval)=4;
        end
    end
    % the rest of the samples we put equal to the last epoch?? 
    no_samples_noscored=NoTotalSamples-interval*numel(scores); 
    Scores(end-no_samples_noscored:end)=scores(end); % we put them as the las scored epoch
end