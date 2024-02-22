close all;
clear;
clc;

%% 1 st layer - Functional Cuneate Spiking Neural Network
%% Primary Afferent Models - SA II and PC/FAII
% Reference Article: Functional Cuneate Spiking Neural Network for e-Skin Indentation Localization
% Authors: A.C.P.R.Costa, M.Filosa, A.B.Soares, C.M.Oddo
% Institute - Scuola Superiore Sant'Anna & Federal University of Uberlândia.

%% Add path to the directory containing the Izhikevich Function
addpath('..\1st Layer\Functions')
%% Fixed Variables
gainSA=[750, 900, 1050, 1200]; % SA's gains
gainPC=[1500, 2000]; % PC's gains
nGainSA=length(gainSA); % Number of gain
nGainPC=length(gainPC); % Number of gain
dt=0.1; % Sampling frequency 100 Hz
f_res=10; % Resample frequency - 10 times

addpath('..\1st Layer\Data'); % Indentation data path
dirName = '..\1st Layer\Data';
D = dir(dirName);

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
    load (name); % Load indentation data
    num_ind=(name(12:end));
    %% Signal segmentation 
    Fz_derivative = diff(LoadCell.Fz);
    l=length(FBG.Time);
    [Min,Indx] = min(Fz_derivative(end-300:end));
    Ind_End=l-300+Indx; % End of the indentation
    [Max,Indx] = max(Fz_derivative(Ind_End-210:Ind_End-150));
    Ind_Start=Ind_End-210+Indx; % Start of the second step of identification
    
    %% Input Current Izihikevich - Raw FBG (SA II)
    TimeFBG=repelem(FBG.Time,f_res, 1);
    DeltaBrggW=repelem(FBG.DeltaBraggW,  f_res, 1); % Hold the sample for n times => 10 times = 1Khz
    FBG_DeltaBrggW_Derivative=diff(FBG.DeltaBraggW); % Derivative Signal
    DeltaBrggW_Derivative=repelem(FBG_DeltaBrggW_Derivative,  f_res, 1); % Hold the sample for n times - 10 times = 1Khz
    FBG_ABS=abs(DeltaBrggW); % Absolute value for SA input current
    
    %% Input Current Izihikevich - FBG Derivative (PC)
    FBG_Derivative_ABS=abs(DeltaBrggW_Derivative); % Absolute value for FA input current
    Ind_Start=Ind_Start*10;
    Ind_End=Ind_End*10;
    
    
    %% Izhikevich - SA II
    SA2.Gain=gainSA;
    PC.Gain=gainPC;
    for j=1:nGainSA
        [sa2, v, u]=Izhikevich(0.02, 0.2, -65, 8, FBG_ABS,gainSA(j), dt);
        SA2.Spk_ABS{j} = sa2;
        clearvars sa2 u v
    end
    for j=1:nGainPC
        %% Izhikevich - PC (FA II)
        [pc, v, u]=Izhikevich(0.02, 0.2, -65, 8, FBG_Derivative_ABS,gainPC(j), dt);
        PC.Spk_ABS{j} =pc;
        clearvars pc u v
    end
    
    %Saving spike data
    name_s=strcat('Output Data/Spikes/Spike_Indentation_',num_ind,'.mat');
    save(name_s, 'SA2', 'PC','TimeFBG','Ind_Start', 'Ind_End')
    
    clearvars SA2 PC TimeFBG
end
