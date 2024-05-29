function RasterPlotFunc(spikes,titulo, marker_size,cr)
%UNTITLED2 Summary of this function goes here
% Input
% *spikes is a matrix NxM where N is the number of primary afferents and M
%is number of sample in ms, the data of is spikes is 0 or 1
% *Titulo is the title of de figure
% *marker_size is the size of the marker
%   Detailed explanation goes here

[l,c]=size(spikes);
aux=1:1:c;
PlotAux=spikes'.*aux';
PlotAux=PlotAux';
dt=1/1000;
t=0.001:dt:8;
dt=1/10000;
t1=0.0001:dt:8;
if cr==0
   stem(t1,PlotAux,'Marker', '.','MarkerSize', marker_size, 'LineStyle', 'none', 'color', 'k' );
    ylim([0.5 c+0.5]);
    xlabel('Time (s)')
    ylabel('Cuneate Neuron ID')
    
else
    colors=[0.6350 0.0780 0.1840
        0.9290 0.6940 0.1250
        0.3010 0.7450 0.9330
        0.8500 0.3250 0.0980
        0.4660 0.6740 0.1880
        0 0.4470 0.7410 ];

    aux=1;

    for i=1:21:c
        
        h(i:i+20)=stem(t,PlotAux(:,i:i+20),'color', colors(aux,:),'Marker', '.','MarkerSize', marker_size, 'LineStyle', 'none');
        hold on
        aux=aux+1;
    end
    yticks(11:21:126);
    yticklabels({'SAII - G1','SAII - G2', 'SAII - G3', 'SAII - G4', 'FAII - G1', 'FAII - G2'})
    ylim([0.5 c+0.5]);
    ylabel({'1^{st} Order','Neurons Spikes'})
end

