function Spine = SpineComputation(Var)
%% Synaptic local Ca2+ time constant (Intrinsic Parameters, Table S2)
% This function computes the spine compartment calcium (Static Template). 
%Look Eq. 14

%Var.DT = 0.1;
DS_Dt = Var.DT;
Td = 12.5/Var.DT; Tr = 4/Var.DT; Tm = 21.3/Var.DT;
Spine.DS_tMax = 150;
DS_t = 0:DS_Dt:Spine.DS_tMax;
% PSP Computation
Spine.DS = (Tm/(Td-Tr)) * (exp(-1*(DS_t/DS_Dt-0)/Td) - exp(-1*(DS_t/DS_Dt-0)/Tr)); % Eq. 14
% PSP peak computation
Spine.Peak = (Tm/Td)*((Tr/Td)^(Tr/(Td -Tr)));

% figure
% plot(DS_t,Spine.DS);
% grid on; xlim([0 145])
% set(gca,'XTick',[0:5:100])

end

