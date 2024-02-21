# Cuneate-Spiking-Neuronal-Network

OVERVIEW

Matlab implementation of the cuneate spiking neuronal network model proposed in the paper: Functional Cuneate Spiking Neuronal Network for e-Skin Contact Localization. The model has two layers, and the codes needed to run each layer are separated into two folders: 1st Layer and 2nd Layer.

The 1st layer folder contains the codes necessary to calculate the spike output of the primary afferents and segment the spike data to be used as input to the second layer.

The 2nd layer folder contains the codes necessary to perform synaptic learning protocol and calculate the spike output of the cuneate neurons. 
_____________________________________

FEATURES

i) 1st Layer Folder:

Main_FirstLayer: Implements the primary afferent models (mechanoreceptors) and calculates the spike output for the different models.

Spikes_Segmentation: Segments the spike output of the first layer to be used as model input for training or for calculating the output of the second neural layer (output of the cuneate neurons). Note that there is a variable called Flag which determines the type of segmentation.

i) 2nd Layer Folder:

Main_Train_2ndLayer: Implements the cuneate neuron model and synaptic learning protocol. 

Main_Output_2ndLayer: Calculates the spike output of the cuneate neurons after the synaptic learning of each neuron in the network.
_____________________________________

INSTALLATION

MATLAB App Version:
Clone the repository or download the source code.
_____________________________________

DATA INPUT

1st layer: Tactile data acquired using FBG sensors, it is noted that the first layer can be adapted for the use of data acquired using other artificial tactile sensors. For testing purposes, some samples of the indentation data acquired can be found in the data folder. For access to the full database, contact the authors.

2nd Layer: Spikes originating from the first layer of slow-adapting and fast-adapting type 2 mechanoreceptors, and initial excitatory synaptic weights.
_____________________________________

ACKNOWLEDGMENTS

Udaya B Rongala for the development of the cuneate neuron model presented in the paper "Intracellular Dynamics in Cuneate Nucleus Neurons Support Self-Stabilizing Learning of Generalizable Tactile Representations".

This project is supported by the following grants: 

i) Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES - Brazil);

ii) Fundação de Amparo à Pesquisa do Estado de Minas Gerais (FAPEMIG - Brazil);

iii) Conselho Nacional de Desenvolvimento Científico e Tecnológico (CNPq - Brazil)

iv) Italian Ministry of Enterprises and Made in Italy (MIMIT) through the Industry 4.0 Competence Center on Advanced Robotics and Enabling Digital Technologies and Systems (ARTES4.0)

v) Tuscany Region through the Tuscany Network for Bioelectronic Approaches in Medicine: AI-based predictive algorithms for fine-tuning of electroceutical treatments in neurological, cardiovascular, and endocrinological diseases (TUNE-BEAM, H14I20000300002)
 
vi) Italian Ministry of Universities and Research (MUR);

vii) National Recovery and Resilience Plan (NRRP), project MNESYS (PE0000006)–A Multiscale integrated approach to the study of the nervous system in health and disease (DN. 1553 11.10.2022).
_____________________________________

DISCLAIMER

All Matlab implementations and functions were implemented with care and tested using the data provided. Nevertheless, they may contain errors or bugs. Please email us any problem you find.
_____________________________________

LICENSING

Please read the details in individual files, as they includes some codes that were previously developed by Udaya B Rongala.
