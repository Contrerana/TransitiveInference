st_cnf=[];
st_cnf.freqband=[9 16];
st_cnf.fsampling=500;
st_cnf.window=0.3; %window to calculate spindle energy (default)
st_cnf.minnumosc=4;%Minimum number of oscillations (default: 4)
st_cnf.timebounds=[0.3,2];%time duration in seconds (default: [0.3,3])
st_cnf.dynamics=30; %slow dynamics in seconds for spindle thresholding (default: 30)
st_cnf.hypnogram=[]; %no need, only N3
st_cnf.stage=[];%scalar indicating the sleep stage (all are in N3)
st_cnf.toFilter=false;%	Filter input in SO band (default = false)
st_cnf.timeFreq=true;%	Time-frequency correction (default = true)
st_cnf.method='adaptative';%Method for spindle detection ('adaptative','fixed').
st_cnf.rawEEG=[];%	Raw EEG wheter the signal is filtered beforehand
for pt=1:numel(List)
    %% load the participant file
    
    for ch=1:EEG2.nbchan
        
        [mx_eventLims,vt_centFreq,vt_eeg]=fn_sleep_detect_spindles(vt_eeg,st_cnf);
    end
end