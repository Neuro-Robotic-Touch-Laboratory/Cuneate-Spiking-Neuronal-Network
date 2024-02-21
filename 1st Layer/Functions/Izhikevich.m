function [spikes, v, u] = Izhikevich( a,b,c,d,I,G,dt)
%UNTITLED2 Summary of this function goes here
%%Output
%spikes - resulting from Izhikevich's neuron (0 or 1)
%v - Membrane potencial (mV)
%u - Membrane recovery variable

%%Input
%a - decay rate 
%b - sensitivity to noise 
%c - resting potential
%d - adaptation rate 
%G - Input current gain
%I - Input current 

%% Defining variables 
[lin,col]=size(I);
I=I.*G; % Input current
v=zeros(lin,col);
u=zeros(lin,col);
spikes=zeros(lin,col);
for i=1:col
    vold=c; % Membrane potencial
    uold=b*vold; % Membrane recovery variable
    for j=1:lin
        v(j,i) = vold + dt*(0.04*vold^2+5*vold+140-uold+I(j,i));
        u(j,i) = uold + dt*(a*(b*vold-uold));
        if v(j,i)>= 30
            v(j,i)= c;
            u(j,i)=u(j,i)+d;
            spikes(j,i)=1;
        end
        vold=v(j,i);
        uold=u(j,i);
    end

end

