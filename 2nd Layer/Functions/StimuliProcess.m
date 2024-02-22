function [Stimuli,Var] = StimuliProcess(Sti,Var)
% Processing the Input stimuli to required config.

dt=1/1000; % Fs =1000Hz -> dt=1/Fs
P1=Var.TimeScale(1)/dt;
P2=Var.TimeScale(2)/dt;
%% Processing the Texture Stimuli (Selecting 1s Data)
for i=1:Var.nSti
    Stimuli{i}.Spk=Sti{i}.Spikes(P1:P2,:);
end

end



