% Concatenate trials

addpath(genpath('main'));
pathname = uigetdir(pwd,'Input Directory');
pathname = fullfile(pathname);
directory = dir(pathname);

count = 1;
for idx = 3:20
    file = directory(idx).folder;
    path = directory(idx).name;
    Intan = read_Intan_RHD2000_file(file,path);   
    allIntan{count} = Intan.amplifier_data(33:96,:);
    count = count+1;
end % load Intan files
% Concatenate intan files for the whole session
Intan.allIntan = horzcat(allIntan{:});
Intan.allIntan = single(Intan.allIntan);
% Fix recording offset
Intan.offset = 1; % second
Intan.offsetSample = Intan.frequency_parameters.amplifier_sample_rate*offset;
disp(['Adjusting for ' offset 'second offset']);
Intan.allIntan = Intan.allIntan(:,offsetSample:size(Intan.allIntan,2)-offsetSample);
clear amplifier_data t_amplifier frequncy_parameters notes aux_input_channels...
    aux_input_data board_dig_in_channels board_dig_in_data amplifier_channels


