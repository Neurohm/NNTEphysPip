% Time-Frequency Analysis
clear S3
params.Fs = 20000;
params.tapers = [5 9];
params.fpass = [0 100];
movingwin = [0.5 0.05];
params.pad = 2;
spikeData = Spikes.Clusters(1).cluster;
Spikes.Clusters.spikeTime;
data = filtData.rawData(12,1:100000)';
[X1,t,f]= mtspecgramc(data,movingwin,params);
[X2,f1]= mtspectrumc(data,params);

%% Spike Coherency
for i = 1:size(Spikes.Clusters,2)
    fixSpiketime{i} = Spikes.Clusters(i).spikeTime';
end


coherencyLFP(:,1) = data;
spikeTime = vertcat(fixSpiketime{:});

% [C,phi,S12,S1,S2,f2,zerosp]=coherencycpt(coherencyLFP,spikeTime,params);
[C,phi,S12,S1,S2,t2,f2,zerosp]=cohgramcpt(coherencyLFP,spikeTime,movingwin,params);

% Plot
figure,
subplot(4,1,1),stack_plot(filtData.lowpassData(12:15,1:100000)); title('LFP Band')
subplot(4,1,2),stack_plot(filtData.commonModeAvg(12,1:100000));title('Spike Band')
subplot(4,1,3),plot_matrix(X1,t,f); colormap(jet)
subplot(4,1,4),imagesc(0:t,f2,C'); clim([0,1]),ylabel('Frequency (Hz)'),axis xy,title('Coherency');
%% Coherency Correlation
idx = find(10<f2 & f2<30);
beta = f(idx);
betaCoherence = C(:,idx)';
betaAvg = mean(betaCoherence);

figure,
subplot(3,1,1),imagesc(0:t2,f2,C'); clim([0,1]),ylabel('Frequency (Hz)'),axis xy,title('Coherency'),colorbar,colormap(jet);
subplot(3,1,2),imagesc(0:t2,beta,betaCoherence),ylabel('Frequency (Hz)')...
    ,axis xy,title('Beta Band Coherency'),colorbar, clim([0 1]);
subplot(3,1,3),plot(Smooth(betaAvg,2)), box off