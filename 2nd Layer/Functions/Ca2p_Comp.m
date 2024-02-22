function [EPSP,IPSP,W,Mem,Spine] = Ca2p_Comp(EPSP,IPSP,Var,t,W,cntCyc,Mem,SigW,StimSlct,Spine)
%Ssyn computation and weights learning technique

% Initializing the Pre. Syn. Neuron Present FLAG array
W.PreStimNeuronArray{cntCyc} = zeros(length(t),Var.nNeuron);

% Initializing next round weights for Learning purposes. Weights learning
% in this cycle will only take effect during next cycle. This is due to the
% time needed by the molecular level (kinases & phospotases) to take change
% and creat effect in the ionic channels.
Mem.Weights(cntCyc+1,:) = Mem.Weights(cntCyc,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initializing the Ssyn matrix
EPSP.Ssyn(1:Var.nNeuron,1:length(t)+EPSP.DS_lim) = 0;
IPSP.Ssyn(1:Var.nNeuron,1:length(t)+IPSP.DS_lim) = 0;
Spine.Ca2p(1:Var.nNeuron,1:length(t)+Spine.Lim) = 0;

Spine.Ca2pRemoval = (Spine.Peak * 75)/100; % Removes 75% of the calcium activity value and this will be the local value of ACa2_loc

% Ssyn computation for EPSP
for Neuron = 1:Var.nNeuron 
    for J = 1:length(EPSP.SpkTimes{Neuron}) %Updates the number of spikes in each neuron
        
        % Where There is Spike, There is a 1 :P
        W.PreStimNeuronArray{cntCyc}(EPSP.SpkTimes{Neuron}(J),Neuron) = 1;
        % (Explination) A(nNeuron, a:b) = (A(nNeuron, a:b) + Template)
        EPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (EPSP.DS_lim-1) ))) ...
            = EPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (EPSP.DS_lim-1) ))) + (Mem.Weights(cntCyc,Neuron)*EPSP.DS);
        
        % IPSP with constant weights
        IPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (IPSP.DS_lim-1) ))) ...
            = IPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (IPSP.DS_lim-1) ))) + (Mem.wIPSP*IPSP.DS);
        
        % Spine Compartment computation w.r.t fn. Spine Computation
        Spine.Ca2p(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (Spine.Lim-1) ))) ...
            = Spine.Ca2p(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (Spine.Lim-1) ))) + Spine.DS(2:end);
        
    end
end


% Sigma EPSP
EPSP.g_synSigma = sum(EPSP.Ssyn);
EPSP.g_synSNorm = EPSP.g_synSigma/Var.nNeuron;
EPSP.g_synSNorm(end-(EPSP.DS_lim-2):end) = [];

% Sigma IPSP
IPSP.g_synSigma = sum(IPSP.Ssyn);
IPSP.g_synSNorm = IPSP.g_synSigma/Var.nNeuron;
IPSP.g_synSNorm = -IPSP.g_synSNorm;
IPSP.g_synSNorm(end-(IPSP.DS_lim-2):end) = [];

% EPSP - IPSP
TOT.g_syn = EPSP.g_synSNorm + IPSP.g_synSNorm; %Synaptic Condutance

% Spine Compartment removing the 75% of nominal Ca2p
Spine.Ca2p = Spine.Ca2p - Spine.Ca2pRemoval; % Here removes 75% of the ca2 channel peaks
Spine.Ca2p(Spine.Ca2p<0)=0;


% Compartment Threshold of Ca2+
% Ca2p.Ssyn(Ca2p.Ssyn > Ca2p.Compartment.Thr) = Ca2p.Compartment.Thr;


% Mem.IPSP_gSyn_SNorm{cntCyc} = IPSP.g_synSNorm;
Mem.WeightsIPSP{cntCyc} = Mem.wIPSP;

% Mem.C_Ssyn{cntCyc} = Ca2p.Ssyn;
% Delta = sum(Ca2p.Ssyn);

% Conductance based ca2p computation
[x,y,CCaEven,Ca2pSpkRt] = Ca2p_Dyn(TOT);

CCat = x;
CCa = y(4,:); % Total calcium channels, eq 12*

Mem.Ca2pSpkFq{cntCyc} = Ca2pSpkRt/1; 


% Learning Threshold Equilibrium
if cntCyc <= 3
    MeanCa2pCum = mean(CCa(50:end-50));
    MeanCCa = MeanCa2pCum * 1.23;
    Mem.Ca2pMean{cntCyc} = MeanCCa;
end

if cntCyc > 3
    MvngWndwSigmaW = mean(Mem.SigmaW(cntCyc-1:-1:cntCyc-3));
    
    if MvngWndwSigmaW >= 10
        MultFactMean = LrngThrAboveEquilibrium(MvngWndwSigmaW); %SynEq
    end
    
    if MvngWndwSigmaW < 10
        MultFactMean = LrngThrBelowEquilibrium(MvngWndwSigmaW); %SynEq
    end
    
    MeanCa2pCum = mean(CCa(50:end-50));
    MeanCCa = MeanCa2pCum * MultFactMean;
    Mem.Ca2pMean{cntCyc} = MeanCCa;
end

%% Learning Threshold
% First Cycle Learning threshold
if cntCyc <= 3
    Thr = MeanCCa;
end

% Learning Threshold
if cntCyc > 3
    % Checking the mean of last 3 presentations Calcium concentration mean
    MvngWndwLrngThr = mean([Mem.Ca2pMean{cntCyc-1:-1:cntCyc-3}]);
    Mem.MvngWndwLrngThr{cntCyc} = MvngWndwLrngThr;
    Thr = MvngWndwLrngThr;
end

Mem.Thr{cntCyc} = Thr;

CCaEvenNorm = CCaEven;

% This "FixedValOfRestingPotential" is a hard variable, which is considered
% form iterations. This is done in-order to remove the resampling effect on
% the total calcium concentration caused by using "resample" function.
FixedValOfRestingPotential = 1.037e-7;
CCaEvenNorm(CCaEvenNorm < FixedValOfRestingPotential) = FixedValOfRestingPotential;

% Learning factor computation -  The Upper(+) and Lower(-) polarity of the
% Calcium concentration with respect to the Learning Threshold.
CCaEvenNorm = CCaEvenNorm - Thr; %Eq 15 parenthesis-> AtotCa2 -(AvgAtotCa2*Syneq)

% NORMALIZING the calcium concentration in-order to meet the effective
% learning weight change variable when multiplied with the Spine calcium
WeightChange = zeros(1,Var.nNeuron);
ContEvolve   = zeros(1,length(t));

if cntCyc > Var.nIdealPresent
    
    for Neuron = 1:Var.nNeuron
        
        for i = 1:length(t)
            ContEvolve(i) = Spine.Ca2p(Neuron,i)*CCaEvenNorm(i); % Parenthesis of eq 15 * AlocCa2 {}
        end
        
       %%Gain factor K
        
        % Caluclating the GAIN factor, w.r.t the Sigmoid
        % SigW(:,1) -> Gain Factor. SigW(:,2) -> No. of ion Channels
        % already present (Existing Weight)
        [~,idx] = min(abs(SigW(:,2)- Mem.Weights(cntCyc+1,Neuron)));
        % Respective weight change of neuron, for next cycle
        RespWChange = sum(ContEvolve) * SigW(idx,1); % Integral of eq 15 (Update of excitatory weights)
        
        %         Mem.ContEvolve{cntCyc,Neuron} = ContEvolve;
        
        % Weight Change w.r.t. each Spine calcium and Main Compartment
        % calcium
        WeightChange(Neuron) = RespWChange;
        
        % Memory Store
        %         Mem.WeightChange(Neuron,cntCyc) = WeightChange(Neuron);
        
        % Weights for Next Cycle of every NEURON
        Mem.Weights(cntCyc+1,Neuron) = Mem.Weights(cntCyc+1,Neuron) +  WeightChange(Neuron);
        
        % Keeping weights, within the hard boundaries for weights
        if Mem.Weights(cntCyc+1,Neuron) >= W.max
            Mem.Weights(cntCyc+1,Neuron) = W.max;
        end
        
        if Mem.Weights(cntCyc+1,Neuron) <= W.min
            Mem.Weights(cntCyc+1,Neuron) = W.min;
        end
        
        ContEvolve   = zeros(1,length(t));
        
    end
    
end

% Re-Sampling data to time windown
% Mem.CCaReSamp{cntCyc} = CCaEven;

% Sigma Weight
SigmaW = sum(Mem.Weights(cntCyc,:));
Mem.SigmaW(cntCyc) = SigmaW;

% Checking for REBOUND SPIKES (if W.IPSP > W.EPSP) && patching the fq. to
% zero at this state (TO AVOID IPSP BLOW-OUT)
if (Mem.wIPSP*Var.nNeuron) > Mem.SigmaW(cntCyc)
    Mem.Ca2pSpkFq{cntCyc} = 0;
end


end

%% Equilibrium Slope Functions (Below Eq. Point) - SynEq
function y = LrngThrBelowEquilibrium(x)
X1 = 10;    X2 = 15;
Y1 = 50;    Y2 = 60;
m = (Y2 - Y1)/(X2 - X1);
y = ((m*x)+30)/50;
end

%% Equilibrium Slope Functions (Above Eq. Point)
function y = LrngThrAboveEquilibrium(x)
X1 = 10;    X2 = 15;
Y1 = 50;    Y2 = 80;
m = (Y2 - Y1)/(X2 - X1);
y = ((m*x)-10)/50;
end