# Cuneate-Spiking-Neuronal-Network


OVERVIEW

Matlab implementation of the cuneate spiking neuronal network model proposed in the paper: "Functional Cuneate Spiking Neuronal Network for e-Skin Contact Localization". The model consists of two neuronal layers, each implemented through a separate code stored in the "1st Layer" and "2nd Layer" folders, respectively, as detailed below.

The "1st Layer" folder contains the codes to: (i) calculate the spiking outputs of the primary afferents; (ii) segment the spike data to be used as input to the second layer.

The "2nd Layer" folder contains the codes to: (i) perform the synaptic learning protocol; (ii) calculate the spiking outputs of the cuneate neurons. 
_____________________________________

FEATURES

1) 1st Layer Folder:

Main_FirstLayer: Implements the primary afferent models (mechanoreceptors) and calculates the spike output for the different models.

Spikes_Segmentation: Segments the spike output of the first layer to be used as model input for training or calculating the output of the second neuronal layer (output of the cuneate neurons). Note that there is a variable called Flag which determines the type of segmentation.

2) 2nd Layer Folder:

Main_Train_2ndLayer: Implements the cuneate neuron model and the synaptic learning protocol. 

Main_Output_2ndLayer: Calculates the spiking outputs of the cuneate neurons after the synaptic learning of each neuron in the network.

More details can be found as comments in the code and function files.
_____________________________________

INSTALLATION

MATLAB Version: 2022a
Clone the repository or download the source code.
_____________________________________

INPUT DATA

1st Layer: Tactile data, i.e., wavelength variations of the FBG sensors.  Note: the first layer can be adapted to be used with data from other types of artificial tactile sensors. For testing purposes, some samples of the indentation dataset can be found in the "Data" folder. For access to the full database, please, contact the authors.

2nd Layer: Spikes originating from the first layer of slow-adapting and fast-adapting type 2 mechanoreceptors, and initial excitatory synaptic weights.
_____________________________________

ACKNOWLEDGMENTS

Udaya B Rongala for the implementation of the cuneate neuron model presented in the paper "Intracellular Dynamics in Cuneate Nucleus Neurons Support Self-Stabilizing Learning of Generalizable Tactile Representations", which inspired this work.

This project is supported by the following grants and institutions: 

i) Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES - Brazil);

ii) Fundação de Amparo à Pesquisa do Estado de Minas Gerais (FAPEMIG - Brazil);

iii) Conselho Nacional de Desenvolvimento Científico e Tecnológico (CNPq - Brazil)

iv) Italian Ministry of Enterprises and Made in Italy (MIMIT) through the Industry 4.0 Competence Center on Advanced Robotics and Enabling Digital Technologies and Systems (ARTES4.0)

v) Tuscany Region through the Tuscany Network for Bioelectronic Approaches in Medicine: AI-based predictive algorithms for fine-tuning of electroceutical treatments in neurological, cardiovascular and endocrinological diseases (TUNE-BEAM, H14I20000300002)
 
vi) Italian Ministry of Universities and Research (MUR);

vii) National Recovery and Resilience Plan (NRRP), project MNESYS (PE0000006)–A Multiscale integrated approach to the study of the nervous system in health and disease (DN. 1553 11.10.2022).
_____________________________________

DISCLAIMER

All Matlab implementations and functions were implemented with care and tested using the data provided. Nevertheless, they may contain errors or bugs. Please email us in case of any problems you encounter.
_____________________________________

LICENSING

Please read the details in individual files, as it includes some codes that are not authored by us.
_____________________________________

@author Ana Clara Pereira R. da Costa – ana-clara-p@ufu.br
@author Mariangela Filosa - mariangela.filosa@santannapisa.it 
@author Alcimar Barbosa Soare - alcimar@ufu.br
@author Calogero Maria Oddo - calogero.oddo@santannapisa.it 

