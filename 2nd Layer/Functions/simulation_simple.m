global params;

t = 0;
tend = 1;

I_in=@(t) 0;


%gs = [0 0 0 -6e-10 -2.5e-9 -9e-10 0 0 0 0 0];
gs = [-6e-10 -1e-9 -2.45e-9 -2.5e-9 -2.6e-9 -3.1e-9 -3.14e-9  -2.1e-9  -4.8e-9  -5.3e-9  -9e-10]; %synaptic conduntance 
gdt = 0.1;
E_syn = 0;

Ig_in = @(t,Vm) gs(round(t/gdt)+1)*(E_syn-Vm);

state = [-62 1 0 6e-9 0 0]
y = state';
x = [0];

while( t < tend )
    result = ode15s(@(t,y) eval_cuneate_simpler(t,y,params,I_in, Ig_in),[t tend],state,odeset('Events',@(t,y) spike_event(t,y),'MaxStep',1e-2));
    t = result.x(end)
    x = [x result.x(1:end)];
    y = [y result.y(:,1:end)];

    state = result.y(:,end);
    state(1) = params.params.EL-I_in(t)/params.params.gL + params.params.Vboost; % Aqui ele atualiza Vm
    state(4) = state(4) + params.params.CCaboost; % Atualiza Caa
end

CCat = x;
CCa = y(4,:);

CCaEven = resample(CCa,CCat,1/gdt);

subplot(2,1,1); plot(CCat,CCa); subplot(2,1,2); plot(CCat,y(1,:));