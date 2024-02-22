close all; clear; clc;

%% 1 st layer - Functional Cuneate Spiking Neural Network
%% Segmentation of spike data (SA II and FA II) for model training or output calculation
% Reference Article: Functional Cuneate Spiking Neural Network for e-Skin Indentation Localization
% Authors: A.C.P.R.Costa, M.Filosa, A.B.Soares, C.M.Oddo
% Institute - Scuola Superiore Sant'Anna & Federal University of Uberlândia

Flag = 1; % Flag = 1 to segment the data for model training, another value to segment the data for calculating the output

% Add path to the directory containing spike data
addpath('..\1st Layer\Output Data\Spikes'); % Spikes data path
dirName = "..\1st Layer\Output Data\Spikes";
D = dir(dirName); % Get list of files in the directory
%% Load indentation data
Data_name = cell(1, length(D)-2);

% Extract data file names from directory
for i=3:(length(D))
    if (strcmpi(D(i).name(end-3:end), '.mat') == 1)
        var23 = length(D(i).name)-4;
        Data_name(i-2) = {D(i).name(1:var23)};
    end
end

for i=1:length(Data_name)
    name=char(Data_name(i));
    load (name);
    % Concatenate spike data from different primary afferents models
    spk=cat(2,SA2.Spk_ABS{1}(1:end-10,:), SA2.Spk_ABS{2}(1:end-10,:),SA2.Spk_ABS{3}(1:end-10,:),SA2.Spk_ABS{4}(1:end-10,:),...
        PC.Spk_ABS{1}, PC.Spk_ABS{2});
    
    % Segment spike data based on flag value
    if Flag == 1
        Spikes =  spk(Ind_Start-20:Ind_End+20 , :); % For model training
        name_s=strcat('Output Data/Spikes Training/',name);
        save(name_s, 'Spikes')
    else
        Spikes = spk(end-8020: end, :); % For calculate the model output
        name_s=strcat('Output Data/Spikes Output/',name);
        save(name_s, 'Spikes')
    end
    
end