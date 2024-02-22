function [EPSP,Var] = DataProcess(Var,EPSP,Stimuli,StimSlct)
% This fn. is used to process and fit the spiking data

clearvars EPSP.SpkTimes;

% Re-arranging the spike times
[l,c]=size(Stimuli{StimSlct}.Spk);
for i=1:c
    
    Spk=Stimuli{StimSlct}.Spk(:,i);
    SpkTimes=find(Spk)';
    EPSP.SpkTimes{i} = SpkTimes;
    
end

end

