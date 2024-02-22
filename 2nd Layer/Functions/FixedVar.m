function [Var,W,Mem,EPSP,IPSP,gVar,t] = FixedVar(Sti,InitW)

% Variables that are fixed throughout the Simulation run

% Time Variables
Var.DT = 1;                       % IF DT CHANGED, CHANGE IN ALL Fn. (D_Ssyn.m, Variable.m)
Var.TimeScale  = [0.01 1.01];
Var.noiseRange = [-5 5];          % +- 5 ms

% Sensory Variables
Var.nActChl  = 4;
Var.nMechTyp = 2;

% Input Data Variables
% CHANGE ALSO THIS PARA IN fn KnownRandSort.m 
Var.nSti = length(Sti);                       % No. of Stimuli

% Simulation Protocol Variables
%% NOT NEEDED UNLESS YOU USE THE Fn. "KNOWNRANDSORT.M"
% CHANGE ALSO THIS PARA IN fn KnownRandSort.m 
Var.nPrn = 100;                     % No. of Presentations
Var.nLTP = 2;                       % No. of Non. LTD SETS (2*nSti)

Var.nIdealPresent = 1;              % Fixed for weight initialization
Var.nLTPpresent   = 2*Var.nSti;              
Var.nMovingThr    = Var.nPrn*Var.nSti;
Var.nPresentations= Var.nIdealPresent + Var.nLTPpresent + Var.nMovingThr;

% Otehr Parameters
Var.nSubPlt  = 5;           
Var.MultFact = 3;                   % Remember the Ca2P.DS_t_Max should be taken care
Var.CompThrCa2pMultFact = 1.5;

% Number of Neurons

Var.nNeuron = 126; % Primary Afferent number

%% Weight Parameters
W.max = 1;
W.min = 0; %0.001;

% Removing the negative values from the seed weights
InitW(InitW<0) = 0;  %0.001) = 0.001;
Mem.Weights(1,1:Var.nNeuron) = InitW;

%% Cuneate Variable Definitions
EPSP.tMax   = ((Var.TimeScale(2)-Var.TimeScale(1))*1e3);
EPSP.t = EPSP.tMax/Var.DT;

%% Conductance Variable
% gSyn
gVar.tau_syn = 4;
% Maximum synaptic conductance constatnt (g_max)
gVar.inp_min = 23e-8;
% Creating Static template based on g_max (gVar.inp_min)
gTmax = 20;
TempT = zeros(1,gTmax/Var.DT); % Initialization
g_syn = zeros(1,gTmax/Var.DT); % Initialization

% Initial Parameters
g_syn(1) = 0;
TempT(1)=0;

% Template
for i=2:gTmax/Var.DT
    TempT(i)=TempT(i-1)+Var.DT;
    if abs(TempT(i)-1)<0.001; g_syn(i-1)=gVar.inp_min; end
    g_syn(i)= g_syn(i-1) - Var.DT/gVar.tau_syn * g_syn(i-1);
end

% Conductance template for the synapses
EPSP.DS_lim = (gTmax/Var.DT);
EPSP.DS = g_syn;

IPSP.DS_lim = (gTmax/Var.DT);
IPSP.DS = g_syn;

%% Time
t  = 1:EPSP.t;

end

