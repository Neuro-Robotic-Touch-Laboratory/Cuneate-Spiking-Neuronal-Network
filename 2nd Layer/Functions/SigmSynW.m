function SigW = SigmSynW
% This function is to create Sigmoid. Its a standalone function - Eq 16.
% Its a sigmoid between Learning Rate and Weight
% Its defined as Synaptic Weight Compensation in the paper.
% This sigmoid makes the potentiation hard for synapse with higher
% weight and makes easy to potentiate for synapse with lower weight.

W.SigMin = 0.1e3/5;
W.SigMax = 1e3/5;

Sig.X0  = 0.005;        % x-value of the sigmoid's midpoint
Sig.L   = 1;            % curve's maximum value
Sig.K   = 0.005;        % steepness of the curve
Sig.Idx_l = -1000;
Sig.Idx_h = 1000;

Idx = 0;

for x = Sig.Idx_l:Sig.Idx_h
    Idx = Idx + 1;
    A(Idx) = Sig.L/(1+exp(-Sig.K*(x-Sig.X0)));
end
 
LIdx = Sig.Idx_l:1:Sig.Idx_h;

% Normalize to [0, 1]:
m = min(LIdx);
range = max(LIdx)-m;
LIdx = (LIdx-m)/range;
% Normalize to given range:
range2 = W.SigMin - W.SigMax;
normalized = (LIdx*range2) + W.SigMax;

SigW(:,1) = normalized;
SigW(:,2) = A;

%% Plot function
% figure; 
% clf;
% p1 = plot(SigW(:,1),SigW(:,2),'b'); hold on; legend(p1,'LTP');
% xlabel('Learning Rate'); ylabel('Weight'); grid on; xlim([0 200]);


end


