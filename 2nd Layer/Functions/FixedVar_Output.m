function [Var,EPSP,IPSP,gVar,t] = FixedVar_Saida(Sti)

% Variables that are fixed throughout the Simulation run

% Time Variables
Var.DT=1; %Var.DT = 0.1;                       % IF DT CHANGED, CHANGE IN ALL Fn. (D_Ssyn.m, Variable.m)
Var.TimeScale  = [0.001 8.002];
% Number of Neurons
Var.nNeuron =126;
Var.nSti = length(Sti);            % Idx of texture stimuli
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
    g_syn(i)= g_syn(i-1) - (Var.DT/gVar.tau_syn) * g_syn(i-1);
  %%  g=gs(i-1)*(1-1/4)
end

% Conductance template for the synapses
EPSP.DS_lim = (gTmax/Var.DT);
EPSP.DS = g_syn;

IPSP.DS_lim = (gTmax/Var.DT);
IPSP.DS = g_syn;

%% Cuneate Variable Definitions
EPSP.tMax   = ((Var.TimeScale(2)-Var.TimeScale(1))*1e3);
EPSP.t = EPSP.tMax/Var.DT;
%% Time
t  = 1:EPSP.t;

end

