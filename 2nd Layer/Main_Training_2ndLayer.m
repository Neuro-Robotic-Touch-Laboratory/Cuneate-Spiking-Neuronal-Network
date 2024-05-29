%% Artificial Cuneate Neuron Model

% Reference Article: Functional Cuneate Spiking Neural Network for e-Skin Indentation Localization
% Authors: A.C.P.R.Costa, M.Filosa, A.B.Soares, C.M.Oddo
% Institute - Scuola Superiore Sant'Anna & Federal University of Uberlândia.
% Adapted from the article: Intracellular dynamics in cuneate nucleus neurons support
% self-stabilizing learning of generalizable tactile representations
% Authors: U.B.Rongala, A.Spanne, A.Mazzoni, F. Bengtsson, C.M.Oddo, H.JÃ¶rntell

clearvars
close all
%% Add path to the directory containing data and functions

addpath('..\2nd Layer\Data')
addpath('..\2nd Layer\Data\Spikes Training')
addpath('..\2nd Layer\Functions')

%% Initialization of Base Neuron Parameters
% Different Intrinsic Parameters (Table 2) are also specified below in code
% this part can be uncommented to run simulation across all the intrensic
% parameters

% Ca2+ activity set point (SetPoint_{Ca2+}, Table 1)
% Neuron Frequency
Iter.Fq = 20; % Basic CN configuration value
Iter.FreqName = {'Fq20'};

% Other  Ca2+ activity set point (Table 1)
% Iter.Fq = [20 40 60 80 100];
% Iter.FreqName = {'Fq20','Fq40','Fq60','Fq80','Fq100'};

% Synaptic local Ca2+ time constants (Tau_{Ca2+_loc}, Table 1)
% This default parameter is defined in "variable.m"

% Synaptic local Ca2+ time constants (Tau_{Ca2+_loc}, Table 1)
% Iter.Ca2pSpine = [6.25 2 10.65 100; 18.75 6 31.95 150; 25 8 42.6 200; 31.25 10 53.25 250];
% Iter.Ca2pSpineName = {'50p','150p','200p','250p'};

% Seed Weight distribution spread (SW Spread, Table 1)
% Iter.Norm = {'Data/Norm4.mat','Data/Norm4b.mat','Data/Norm4c.mat',...
% 'Data/Norm4d.mat','Data/Norm4e.mat'};
% Iter.NormName = {'4','4b','4c','4d','4e'};

% Number of CN 
% Repeting the whole simulation, to check Repeatability.
Iter.Rep = 1036;
Iter.RepName = {'1'};

% Maximum synaptic conductance constant (g_{max}, Table 1)
% % Basic CN configuration value defined in "variable.m"

% Maximum synaptic conductance constant (g_{max}, Table 1)
% Iter.CellSize = [9e-7 9e-8 23e-9 9e-9];
% Iter.CellSizeName = {'9e7' '9e8' '23e9' '9e9'};


%% Iterative Loop across all the Intrinsic Parameters Specified in Table 1
% for CntCa2pSpine = 1:numel(Iter.Ca2pSpine(1,:))
% for CntCellSize = 1:numel(Iter.CellSize)
% for CntNorm = 1:numel(Iter.Norm)

%% Initializing Index in absence of Iterative loops from above code (of FOR loops)
% NOTE: Incase running for loops across all the intrinsic parameters, please
% comment/delete the following two lines of code.
CntNorm = 1;
CntFq = 1;


%% Known Random Sort (KRS) (Randomized order of stimuli presentations to model).
% Function for generating "Pseudo-Randomized Stimuli Presentation
% Order" The order used in this article are saved as "CycSort.mat"
% Note: In-order to regenerate the order, please uncomment the next
% line of code. And comment/delete line 86 ('load(Data/KRS.mat)').
% CycSort = KnownRandSort;

% CycSort is a randomized order of stimuli presentation to the synaptic
% learning model.
load('OrdemTrain01.mat');

%% PreProcessed Stimuli Input Data (Input Primary Afferent Spikes)
% Indentation stimuli (only second indentation phase)
load('TrainIndexes.mat')
nFold=1; 
c=length(TrainIndx{1});
Ind=TrainIndx{1}(:); % 
for i=1:c
   name=strcat('Spike_Indentation_',num2str(Ind(i)),'.mat');
   Sti{i}=load(name);
end
clearvars TrainIndx TestIndx

%% Loading all fixed variables
% gMax definition inside this function (intrinsic parameters, Table 1)

%% Loading the Optimized Neuronal Ca2+ dynamic model parameters
init_simple
load('Data/used_in_report.mat'); % Table S2 Parameters

%% Sigmoid function (Fig. 3I, learing effect of synaptic weight change).
SigW = SigmSynW;
%% Loading Inital Excitatory Weights
load('Initial_W_Exc_3D_1036CN.mat') % Loads the initial excitatory weights (1036 CN - 3D Skin)
%% Loop for each CN
for CntRep =  1:1036%CN_Field
    %% Loading the "Initial Weight Distribution (Seed Weight)"
    % distribution slelcted "cntNorm"
    InitW = y(CntRep,:);
    InitW =InitW';

    %         clearvars y
    
    [Var,W,Mem,EPSP,IPSP,gVar,t] = FixedVar(Sti,InitW);
    
    %% Pre-Processing the Input Primary Afferent Spikes.
    [Stimuli,Var] = StimuliProcess(Sti,Var);
       
    %% Variables

    Mem.TotPresent = numel(CycSort);    % Total Presentation
    
    %% Synaptic local Ca2+ time constant (Intrinsic Parameters, Table S2)
    % Spine compartment calcium computation (Fig. 3C, [Delta(A^{Ca2+}_{loc})], Static)
    Spine = SpineComputation(Var);
    Spine.Lim = (Spine.DS_tMax/Var.DT);
    
     
    %% Loop for N cycle stimuli presentation  (Simulation Run)
    
    for cntCyc = 1:length(CycSort)
                      
        %
                if cntCyc == 10
                    break;
                end
        
        %% Selecting the Stimuli from randomized order
        StimSlct = CycSort(cntCyc);
        
        
        %% IPSP  - Inhibitory post synaptic potential
        if cntCyc == 1
            Mem.wIPSP = 10/80; % to EQ point
        end
        
        if cntCyc > 5
            % Checking the mean of last 5 cycles Calcium Spike Rate
            MvngWndwCa2pSpkFq = mean([Mem.Ca2pSpkFq{cntCyc-1:-1:cntCyc-5}]);
%             Mem.MvMvngWndwCa2pSpkFq{cntCyc} = MvngWndwCa2pSpkFq;
            
            % Slope functions
            DeltaWipsp = dIPSP(Iter,MvngWndwCa2pSpkFq,CntFq);
            Mem.wIPSP = Mem.wIPSP + DeltaWipsp;
            
            % Hard bounds for IPSP weights
            if Mem.wIPSP < 0
                Mem.wIPSP = 0;
            end
        end
        
        %% Mem Elelmests on First RUN
        if cntCyc == 1; Mem.Delta(length(t)+EPSP.DS_lim) = 0; end
        
        %% Clearning fig every cycle for inp. raster plots
        %         if cntCyc > 1; delete(Var.h2); end
        
        %% Sorting the spikes according to range
        [EPSP,Var] = DataProcess(Var,EPSP,Stimuli,StimSlct);
        
        %% Calcium conductance
        [EPSP,IPSP,W,Mem,Spine] = Ca2p_Comp(EPSP,IPSP,Var,t,W,cntCyc,Mem,SigW,StimSlct,Spine);
        
       
    end


    % Removing some data across iterations to save memory
    Mem.E_Ssyn = []; Mem.gSyn_Sigma = [];
    
    Mem.CycSort = CycSort;
    Name=strcat('Output/Output Training/Output Training 01/FinalWeigth_RecpField_CN', num2str(CntRep),'.mat');
    w_exc=Mem.Weights(end-1,:); % Final excitatory weights
    w_inb=cell2mat(Mem.WeightsIPSP(1,end)); % Final Inhibitory weights
    W_Exc=Mem.Weights;
    W_Inib=Mem.WeightsIPSP;
    
    save(Name, 'w_exc', 'w_inb');
    Name=strcat('Output/Output Training/Output Training 01/EvolutionWeigth_RecpField_CN', num2str(CntRep),'.mat');
    save(Name,'W_Exc','W_Inib' );
   %% Workspace display
    fprintf('CN - %03d \n', CntRep);
       
    clearvars -except Iter CntFq CntNorm CntRep y Sti CycSort SigW
  
end

