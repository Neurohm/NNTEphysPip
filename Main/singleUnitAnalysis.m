function Spikes = singleUnitAnalysis(fpath,VR_data)
path = [fpath,'/postAutoMerge'];
%% Read in kilosort data for matlab analysis
SpikeClusters = readNPY(fullfile(path, 'spike_clusters.npy'));
SpikeSamples = readNPY(fullfile(path, 'spike_times.npy'));

%% Analysis
Spikes.SpikeClusters = SpikeClusters;
Spikes.SpikeSamples = SpikeSamples;
Spikes = clusterSort(Spikes);
% sizePlot = ceil(sqrt(size(Spikes.Clusters,2)));
count = 1;
for i = 1:size(Spikes.Clusters,2)
    if isempty(Spikes.Clusters(i).cluster)
    else
        for ii = 1:size(Spikes.Clusters(i).cluster,2)
            x = Spikes.Clusters(i).cluster;
            y = ones(1,length(Spikes.Clusters(i).cluster));
        end
    end
end
% ISI
Spikes = ISI(Spikes,0.005);

Spikes = rateMap(Spikes,VR_data);
% Clustered Projection
% CLusterless Projection
%% Plot All
figure('name','Spike Map'),spikeImage = spike_map(Spikes.VR.spikeCount',(1:Spikes.VR.position(end)*2));
