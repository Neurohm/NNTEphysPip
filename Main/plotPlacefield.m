function plotPlacefield(Spikes)

%Parse
placeFieldMap = Spikes.PlaceFields.placeFieldMap;
placeFieldperTrial = Spikes.PlaceFields.placeFieldperTrial;
allplaceFields = Spikes.PlaceFields.allplaceFields;
sortedPlaceFields = Spikes.PlaceFields.sortedPlaceFields;
normPlaceFields = Spikes.PlaceFields.normPlaceFields;
populationVector = Spikes.PlaceFields.populationVector;

figure('Name','Place Field Candidates');
trackLength = 200;
disp(['Track Length set to ' num2str(trackLength)])
for neuron = 1:size(Spikes.PlaceFields.placeField,2)
    position = 1:trackLength;
    s = ceil(sqrt(size(Spikes.PlaceFields.placeField,2)));
    subplot(s,s,neuron),spike_map(placeFieldMap(:,:,neuron),position);
    axis tight, axis off, colorbar off;
    title(['PF ' num2str(neuron)]);
end

for perTrial = 1:size(placeFieldperTrial,3)
    figure('Name','Place Field per Trial'),spike_map(placeFieldperTrial(:,:,perTrial),position);
end

figure('Name','All Place Fields across Trials')
spike_map(allplaceFields,1:size(allplaceFields,2));

% Sort Place Fields
figure('Name','Sorted Place Fields'),spike_map(sortedPlaceFields,position);
figure('Name','Normalized Place Fields'),spike_map(normPlaceFields(:,1:100),position);
% Population Vector
figure('Name','Spatial Scale Factor'),htmp(populationVector,20);

end
