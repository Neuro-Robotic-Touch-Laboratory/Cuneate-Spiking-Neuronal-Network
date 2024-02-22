function [x,y,CCaEven,Ca2pSpkRt] = Ca2p_Dyn(TOT)
% Anton calcium dynamics

global params;

t = 0;
tend = 1;%EPSP.tMax;

I_in = @(t) 0;

gs = -TOT.g_syn; %[-6e-10 -9e-10 -2e-9 -2.2e-9 -2.7e-9 -2.8e-9 -5e-9];%
% gs = [-6e-10 -9e-10 -2e-9 -2.2e-9 -2.7e-9 -2.8e-9 -5e-9];
gdt = 1/1000;%EPSP.Dt; %1;
E_syn = 0;

Ig_in = @(t,Vm) gs(round(t/gdt)+1)*(E_syn-Vm);

state = [-62 1 0 9e-9 0 0];
y = state';
x = [0];

while( t < tend )
    result = ode15s(@(t,y) eval_cuneate_simpler(t,y,params,I_in, Ig_in),[t tend],state,odeset('Events',@(t,y) spike_event(t,y),'MaxStep',1e-2));
    t = result.x(end);
    x = [x result.x(1:end)];
    y = [y result.y(:,1:end)];

    state = result.y(:,end);
    state(1) = params.params.EL-I_in(t)/params.params.gL + params.params.Vboost;
    state(4) = state(4) + params.params.CCaboost;
end

CCat = x;
CCa = y(4,:);


CCaEven = resampleNew(CCa,CCat,1/gdt);

% TOT Spk Rate
a = y(1,:) >= -40;
Ca2pSpkRt = sum(a);


end