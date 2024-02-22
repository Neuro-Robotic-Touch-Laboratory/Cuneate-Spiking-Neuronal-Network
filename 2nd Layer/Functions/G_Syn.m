function [g_syn] = G_Syn(Sti,EPSP,IPSP,Var,w_exc, w_inb,t)

%%This function calculates the cuneate neuron synaptic conductance

dt=1/1000; % Fs = 1000 Hz
P1=Var.TimeScale(1)/dt; % Determines the segmentation of the input signal
P2=Var.TimeScale(2)/dt; %Determines the segmentation of the input signal
P2=fix(P2);
%% Processing the Stimuli (Selecting nSenconds Data)
for i=1:Var.nSti
     Stimuli{i}.Spk=Sti.Spikes(P1:P2,:);
	 
end

for k=1:Var.nSti
    clearvars EPSP.SpkTimes;
    [l,c]=size(Stimuli{k}.Spk);
    for i=1:c
        Spk=Stimuli{k}.Spk(:,i);
        SpkTimes=find(Spk)';
      EPSP.SpkTimes{i} = SpkTimes;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    W.PreStimNeuronArray = zeros(length(t),Var.nNeuron);
    % Initializing the Ssyn matrix
    EPSP.Ssyn(1:Var.nNeuron,1:length(t)+EPSP.DS_lim) = 0;
    IPSP.Ssyn(1:Var.nNeuron,1:length(t)+IPSP.DS_lim) = 0;
    % Ssyn computation for EPSP
    for Neuron = 1:Var.nNeuron 
        for J = 1:length(EPSP.SpkTimes{Neuron}) 
            
            % Where There is Spike, There is a 1 :P
%             W.PreStimNeuronArray{k}(EPSP.SpkTimes{Neuron}(J),Neuron) = 1;
            % (Explanation) A(nNeuron, a:b) = (A(nNeuron, a:b) + Template)
            EPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (EPSP.DS_lim-1) ))) ...
                = EPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (EPSP.DS_lim-1) ))) + (w_exc(1,Neuron)*EPSP.DS);
            
            % IPSP with constant weights
            IPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (IPSP.DS_lim-1) ))) ...
                = IPSP.Ssyn(Neuron,(EPSP.SpkTimes{Neuron}(J):(EPSP.SpkTimes{Neuron}(J) + (IPSP.DS_lim-1) ))) + (w_inb*IPSP.DS);
            
        end
    end
    
    
    % Sigma EPSP
    EPSP.g_synSigma = sum(EPSP.Ssyn);
    EPSP.g_synSNorm = EPSP.g_synSigma/Var.nNeuron;
    EPSP.g_synSNorm(end-(EPSP.DS_lim-2):end) = [];
    
    % Sigma EPSP
    IPSP.g_synSigma = sum(IPSP.Ssyn);
    IPSP.g_synSNorm = IPSP.g_synSigma/Var.nNeuron;
    IPSP.g_synSNorm = -IPSP.g_synSNorm;
    IPSP.g_synSNorm(end-(IPSP.DS_lim-2):end) = [];
    
    % EPSP - IPSP
    g_syn{k} = EPSP.g_synSNorm + IPSP.g_synSNorm; % Synaptic Condutance
end