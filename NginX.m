% clear; clc; 
% close all;
addpath(genpath('main'));
IntanConcatenate
% Intan = read_Intan_RHD2000_file(); %load intan data
useGPU = 0;
fpath    = Intan.path; % where on disk do you want the analysis? ideally and SSD...
pathToYourConfigFile = strcat(pwd,'/main/'); % for this example it's ok to leave this path inside the repo, but for your own config file you *must* put it somewhere else!  
run(fullfile(pathToYourConfigFile, 'config_eMouse.m'))
make_UCLAMouseChannelMap(fpath); % Creates channel map for electrode array
%%
% filtData = preprocess_filtering(Intan.allIntan(:,1:400000),Intan.t_amplifier);
%% Ripples
% [Ripples,filtData] = SWR(Intan);
% plotClusterless(Ripples,filtData,Intan)


%% Kilosort Analysis
kilosortPrep(Intan.allIntan,fpath)
set(0,'DefaultFigureWindowStyle','normal')
rez = KilosortAnalysis(fpath,ops);
% now fire up Phy and check these results. There should still be manual
% work to be done (mostly merges, some refinements of contaminated clusters). 
%% AUTO MERGES 
% after spending quite some time with Phy checking on the results and understanding the merge and split functions, 
% come back here and run Kilosort's automated merging strategy. This block
% will overwrite the previous results and python files. Load the results in
% Phy again: there should be no merges left to do (with the default simulation), but perhaps a few splits
% / cleanup. On realistic data (i.e. not this simulation) there will be drift also, which will usually
% mean there are merges left to do even after this step. 
% Kilosort's AUTO merges should not be confused with the "best" merges done inside the
% benchmark (those are using the real ground truth!!!)

%% LFP
set(0,'DefaultFigureWindowStyle','normal')
LFP = fastpreprocess_filtering(Intan.allIntan,8192);
LFP = bestLFP(LFP);
LFP = bandFilter(LFP);
LFPplot(LFP)
%% CSD
[CSDoutput]  = CSD(flip(LFP.LFP(:,1:1024)'/1E6,1),1024,2E-5);
%% Looking at single units
set(0,'DefaultFigureWindowStyle','docked')
Spikes = singleUnitAnalysis(fpath,VR_data);
%%
set(0,'DefaultFigureWindowStyle','normal')
[spikeAmps, spikeDepths, templateDepths, tempAmps, tempsUnW, templateDuration, waveforms] =...
    templatePositionsAmplitudes(fpath,ycoords);
% figure,
% plot(waveforms(1:30,20:end-20)','color',[0.5 0.5 0.5 0.25]), hold on;
% plot(mean(waveforms(1:30,20:end-20),1),'k','LineWidth',2)
sortedSpikeRate = depthSpikePlot(Spikes,templateDepths);
%% Time-Frequency Analysis
TimeFreq = tfAnalysis(Spikes,LFP);
plotTF(TimeFreq,LFP)
%% Place Fields
Spikes = detectPlacefield(Spikes);
Spikes = placeFieldAnalysis(Spikes);
plotPlacefield(Spikes);