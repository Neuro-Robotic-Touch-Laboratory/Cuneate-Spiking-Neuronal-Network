function [ rate ] = eval_cuneate_simpler( time, state, params, I_in, Ig_in, synapses )
% I_in should be a function of time
% Ig_in should be a function of time and membrane potential

if( nargin < 6 )
    synapses = {};
end

p = params.params;

eqCaa = @(V) 0 + 1./(1+exp((p.eqCaa1-V)/p.eqCaa2)); %Eq 6 (1)
eqCai = @(V) 1 - 1./(1+exp((p.eqCai1-V)/p.eqCai2)); %eq 6 (2)
eqKCa = @(C) 1./(1+exp((p.eqKCa1-C)/p.eqKCa2)); %Eq. 9 (2)
eqKVm = @(V) 1./(1+exp((p.eqKVm1-V)/p.eqKVm2)); % Eq. 9 (1)

Vshell = pi*p.dcell^2*p.dshell; %Cell volume where Ca2 ions are processed

%Defines the initial state
Vm = state(1);

xCaa = state(2);
xCai = state(3);
CCa = state(4);
xKCa = state(5);
xKVm = state(6);

dCa = -p.BCa*p.gCa*xCaa^3*xCai*(Vm-p.ECa)/Vshell - (CCa-p.CCarest)/p.tauCa; %Eq 7

dVm = -p.gL*(Vm-p.EL); % Il (Eq. 1)

global enable;

if(enable.I_in)
   dVm = dVm - I_in(time); %Iext
end

if(enable.Ig_in)
   dVm = dVm - Ig_in(time, Vm);  %ISyn
end

if(enable.EIF)
   dVm = dVm + p.gL*p.deltaT*exp((Vm-p.Vt)/p.deltaT); % Eq. 2 Ispike
end

if(enable.KCa)
   dVm = dVm - p.gK*xKCa^4*xKVm^4*(Vm - p.EK); % Eq 4 (2) Iion
end

if(enable.Ca)
   dVm = dVm - p.gCa*xCaa^3*xCai*(Vm-p.ECa); % Eq 4 (1) Iion
end


for i=1:length(synapses)
   s = synapses{i};
   dVm = dVm - s.gS/p.Cm*eval_synapse(time, s.last_spike, s.last_conductance, s.td, s.tau1, s.tau2 )*(Vm-s.ES); 
end

dVm = dVm/p.Cm; %Eq 1 (Divide pela Capacitância

rate = [dVm;...
       -(xCaa-eqCaa(Vm))/p.tauEqCaa;... %Eq 5
       -(xCai-eqCai(Vm))/p.tauEqCai;...  %Eq 5
       dCa;...
       -(xKCa-eqKCa(CCa))/p.tauEqKCa;... %Eq 8
       -(xKVm-eqKVm(Vm))/p.tauEqKVm]; %Eq 8
   
end

