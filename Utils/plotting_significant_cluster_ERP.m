function plotting_significant_cluster_ERP (diff_cond,stats,fs,layout,timestep,name)
% Adapted from fieldtrip tutorials and 
% diff_cond=GAcond1-GAcond2;
% stats result from ft_timelockstatistics
% fs: sampling frequency (temporal resolution)
% layour for plotting
% timestep between time windows for each subplot (in seconds)
% name: string with nme to save pics
%
%
% Lorena Santamaria
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set variables needed for plotting
sample_count = length(stats.time); % number of temporal samples in the statistics object
j = stats.time(1):timestep:stats.time(end);   % Temporal endpoints (in seconds) of the ERP average computed in each subplot
m = 1:timestep*fs:sample_count+1;  % same than j but in samples instead of seconds
 
% find positive clusters
pos_clusters_pvals=[stats.posclusters(:).prob];
pos_clust=find(pos_clusters_pvals<0.05);
pos=ismember(stats.posclusterslabelmat,pos_clust);

% find neg clusters
neg_clusters_pvals=[stats.negclusters(:).prob];
neg_clust=find(neg_clusters_pvals<0.05);
neg=ismember(stats.negclusterslabelmat,neg_clust);
% stats has a p_mask value that is the sum of pos and neg, we want to plot
% separately
cfg=[];cfg.highlight='on';cfg.comment='xlim';cfg.layout=layout;
cfg.highlightcolor     = [0 0 0];
cfg.highlightsize      = 8;
cfg.highlightfontsize  = 10;

for tt=1:length(j)-1
    cfg.xlim=[j(tt) j(tt+1)]; 
    cfg.zlim=[-1.6 2.6];
    interval=pos(:,m(tt):m(tt+1));interval=sum(interval,2);
    interval=interval>=timestep*fs;
    if sum(interval)==0        
       continue% there is nothing significant so we dont plot it
    end
    cfg.highlightchannel=find(interval);
    figure;ft_topoplotER(cfg,diff_cond);colorbar;
    saveas(gcf,[name '_PosCluster_time_' num2str(j(tt)) '_to_' num2str(j(tt+1)) '.tiff']);
end