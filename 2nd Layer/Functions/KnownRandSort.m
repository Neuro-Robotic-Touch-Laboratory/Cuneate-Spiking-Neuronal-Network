function CycSort = KnownRandSort
% Known Random Parameters
% CycSort presents a randomized order of stimuli presentation
% to the synaptic learning model. This order is randomized, but
% should be kept constant through out all the repitetions (across
% all the intrinsic parametes).

% Variable Definitions
nSti = 1385; % Number of Stimuli
nPrn = 1; % Number of Presentation of each Stimuli

% Temporary Variables & Counters
cntCyc = 0;
Cyc = zeros(1,nSti*nPrn);

for i = 1:nPrn
    for j = 1:nSti
        cntCyc = cntCyc + 1;
        Cyc(cntCyc) = j;
    end
end

% Randomizing the order of presentation
CycSort = Cyc(randperm(length(Cyc)));

CycSort = [CycSort]; % Added 1 in before for Ideal Condition
save('OrdemTrain01.mat','CycSort' );

end

