%% 2 nd layer output - Functional Cuneate Spiking Neural Network %%
% Calculation of the spike output of cuneate neurons
% Reference Article: Functional Cuneate Spiking Neural Network for e-Skin Indentation Localization
% Authors: A.C.P.R.Costa, M.Filosa, A.B.Soares, C.M.Oddo
% Institute - Scuola Superiore Sant'Anna & Federal University of Uberlândia.

%% Clear workspace, close all figures, and clear command window
clear;
close all;
clc;

% Add paths to directories containing necessary files
addpath('..\2nd Layer\Output\Output Training\Output Training 01');
addpath('..\2nd Layer\Data');
addpath('..\2nd Layer\Data\Spikes Output')

%% Initial variables

nCN = 1036; % Number of cuneate neurons
W_exc = zeros(nCN,126); % Excitatory synaptic weights
W_inb = zeros(nCN); % Inhibitory synaptic weights

% Load synaptic weight data for each cuneate neuron
for i = 1:nCN
    name = strcat('FinalWeigth_RecpField_CN', num2str(i),'.mat');
    load(name);
    W_exc(i,:) = w_exc;
    W_inb(i) = w_inb;
end

% Initialize neuron parameters
init_simple; % Neuron input current
load('Data/used_in_report.mat'); % Load data used in the report
global params;
tend = 8; % Duration of data (8 seconds)

gdt = 1/1000; % Time step for simulation (1 ms)
E_syn = 0;

% Load indentation indexes
load('TrainIndexes.mat')
nSti = length(TestIndx{1});
Ind = TestIndx{1}(:);

% Loop over each indentation stimulus
for i=1:nSti
    name=strcat('Spike_Indentation_',num2str(Ind(i)),'.mat');
    Sti=load(name);
    [Var,EPSP,IPSP,gVar,T] = FixedVar_Output(Sti);
    CntCN=1;
    aux=Ind(i);
    % Loop over each position (X,Z) - Cuneate somatotopic map matrix
    for X=1:28
        for Z=1:37
            % Calculate synaptic conductance
            [g_syn] = G_Syn(Sti,EPSP,IPSP,Var,W_exc(CntCN,:), W_inb(CntCN),T); %Synaptic Condutance
            gs = -(cell2mat(g_syn));
            Ig_in = @(t,Vm) gs(round(t/gdt)+1)*(E_syn-Vm);
            
            % Initialize time and state variables
            t = 0;
            I_in = @(t) 0;
            state = [-62 1 0 9e-9 0 0];
            y = state';
            x = [0];
            % Simulate neuron dynamics
            while( t < tend )
                result = ode15s(@(t,y) eval_cuneate_simpler(t,y,params,I_in, Ig_in),[t tend],state,odeset('Events',@(t,y) spike_event(t,y),'MaxStep',1e-2));
                t = result.x(end);
                x = [x result.x(1:end)];
                y = [y result.y(:,1:end)];
                
                state = result.y(:,end);
                state(1) = params.params.EL-I_in(t)/params.params.gL + params.params.Vboost;
                state(4) = state(4) + params.params.CCaboost;
            end
            
            % Store membrane potential and calcium concentration
            CCat{CntCN} = x;
            Vm {CntCN}= y(1,:);
            
            ponter=(y(1,:)> -40); %  Spike threshold
            ind = find(ponter==1);
            t_disp=CCat{CntCN}(1,ind);
            spikes=zeros(1,80001); % Resample for 1 KHz - 8 seconds of data
            spikes(floor (t_disp*10000))=ones(size(t_disp));
            SpikesCN(Z,X,:)=spikes;
            
            clearvars y x result state
            CntCN=CntCN+1;
        end
    end
    % Save membrane potential data
    name = strcat('Output/Output Model/Output 01/CN_Vm_Indentation_',num2str(Ind(i)));
    save(name,'Vm', 'CCat' );
    % Save cuneate spike data
    name = strcat('Output/Output Model/Output 01/CN_Spike_Indentation_',num2str(Ind(i)));
    save(name,'SpikesCN');
    clearvars CCat Vm SpikesCN   
end
