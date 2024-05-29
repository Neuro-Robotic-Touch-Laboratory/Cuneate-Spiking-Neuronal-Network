close all; clear; clc;

%% Artificial Cuneate Neuron Model 

% Reference Article: Functional Cuneate Spiking Neural Network for e-Skin Indentation Localization
% Authors: A.C.P.R.Costa, M.Filosa, A.B.Soares, C.M.Oddo
% Institute - Scuola Superiore Sant'Anna & Federal University of Uberlândia.

%% This script computes error prediction and generates result figures

%Add path to the directory containing data 
% addpath('D:\OneDrive\Doutorado\Neuro-Touch Lab\Modelo Neuromórfico\17-02-2023\Indentações'); % Indentatation data
addpath ('D:\OneDrive\Doutorado\Neuro-Touch Lab\Modelo Neuromórfico\06-04-2023\Cuneate Nucleos\Neurônio Cuneiforme 03-05-23\Cuneate Model PNAS\Plot Results\Data\CN Spike Output\After Synaptic Learning'); % Folder with CN output after training
addpath('D:\OneDrive\Doutorado\Neuro-Touch Lab\Modelo Neuromórfico\06-04-2023\Cuneate Nucleos\Neurônio Cuneiforme 03-05-23\Cuneate Model PNAS\Plot Results\Data') % Folder with necessary Data
addpath('D:\OneDrive\Doutorado\Neuro-Touch Lab\Modelo Neuromórfico\06-04-2023\Cuneate Nucleos\Neurônio Cuneiforme 03-05-23\Cuneate Model PNAS\Plot Results\Data\CN Spike Output\Before Synaptic Learning')% Folder with CN output after training
% addpath('D:\OneDrive\Doutorado\Neuro-Touch Lab\Modelo Neuromórfico\06-04-2023\Cuneate Nucleos\Neurônio Cuneiforme 03-05-23\Cuneate Model PNAS\2nd Layer\Data\Spikes Output') % 1st layer output spikes

% Loading data
FBG_Sensors=readtable('FBGPositions3D.txt');  % Read FBG sensor positions
FBG_Sensors=table2array(FBG_Sensors);
Indentations=readtable('Centroids_SkinRS.txt'); % Read indentation centroids positions
Indentations=table2array(Indentations);

load ('CentroideCN_3D.mat')  % Load 3D centroid data
load('Skin.mat') % Load E-skin mesh with 1036 CN
load('TrainIndexes.mat') % Load training ans test indexes
load('Contour_Skin.mat') % Load e-skin contour

dt_f=1/100; % Delta time for the force signal - Fs = 100 Hz
T_F=0.01:dt_f:8; % Time vector

%% Predicting localization error from data after synaptic learning
for j=1:4 % k-fold
    nSti=length(TestIndx{j}); % Number of stimuli
    for i=1:nSti
        aux = TestIndx{j}(i);
        name=strcat('CN_Spike_Indentation_', num2str(aux),'.mat');
        load(name)
        aux2=1;
        Nspks = sum(SpikesCN,3);
        for x=1:28
            for z=1:37
                Nspks2(aux2)=Nspks(z,x);
                aux2=aux2+1;
            end
        end
       
        Weighted_loc=(sum(Centroide.*Nspks2'))/sum(Nspks2); % Calculate weighted location of spikes
        Erro(i)= sqrt((Indentations(aux+1,1)-Weighted_loc(1,1))^2+(Indentations(aux+1,3)-Weighted_loc(1,3))^2); % Calculate error between actual and estimated locations
         
        %% Plot Fig 4 - Skin colormap and 1st and 2nd Layer spikes of one indentation 
        if j==1 && i==2
            fig1=figure;
            fig1.WindowState = 'fullscreen';
            % Force
            load(strcat('Indentation',num2str(aux)));
            Fz_derivative = diff(LoadCell.Fz);
            l=length(FBG.Time);
            [Min,Indx] = min(Fz_derivative(end-300:end));
            Ind_End=l-300+Indx; % End of the indentation
            [Max,Indx] = max(Fz_derivative(Ind_End-210:Ind_End-150));
            Ind_Start=Ind_End-210+Indx;
            subplot(5,2, 1)
            Fz=(LoadCell.Fz(end-802:end,1))';
            Fz=Fz(1:800);
            plot(T_F,Fz,'LineWidth', 1.5, 'color', [0 0.4470 0.7410])
            ylabel({'Z-axis','Force (N)'})
            box off
            
            % Raster plot Primary Afferents
            name=strcat('Spike_Indentation_', num2str(aux),'.mat'); % 1st Layer output
            load(name)
            subplot(5,2,[3, 5])
            RasterPlotFunc(Spikes(1:8000,:) ,strcat('Primary Afferents Spikes - Indentation ',num2str(aux)),5, 1);
            box off
            
            % Raster plot Cuneate Neuron
            subplot(5,2,[7,9])
            spk=reshape(SpikesCN,[1036,80001]);
            spk=spk(:,1:80000);
            titulo=(strcat('Spikes Cunaete Neurons Before Learning - Indentation ', num2str(aux)));
            RasterPlotFunc(spk',titulo, 5,0)
            box off
            
            %Skin Colormap
            subplot(5,2,[2,4,6, 8, 10])
            plot(Point_B(:,1),Point_B(:,2),'k')
            hold on;
            surf(Xq,Zq,Yq,Nspks);
            axis equal
            scatter3(Sx,Sz,Sy+4,'ko','filled');
            ylim([-2, 150])
            xlim([-55, 55])
            xticks([-50,-40,-30,-20,-10, 0, 10, 20, 30, 40 ,50]);
            ytic=0:10:140;
            yticks(ytic);
            box off
            view(2)
            hold off;
            colormap(jet)
            set(gca,'XDir','normal')
            c=colorbar;
            c.Label.FontSize = 14;
            c.Label.String ='Cumulative Spike Number';
            xlabel('x (mm)' )
            ylabel('y (mm)')
            
            % Save the figure as a PNG file
            saveas(fig1,'Fig 4','png')
            close
        end
         %% Plot Fig 5 - Skin colormap and weighted location
        if j==1 && i==217
            fig2=figure;
            fig2.WindowState = 'fullscreen';
           % First subplot - Skin sufarce plot
            subplot(1,2,1)
            hold on
            surf(Xq,Zq,Yq,Nspks);
            axis equal
            scatter3(Sx,Sz,Sy+4,'ko','filled');
            xlim([-55 55])
            ylim([-2 150])
            
            xticks([-50,-40,-30,-20,-10, 0, 10, 20, 30, 40 ,50]);
            ytic=0:10:150;
            yticks(ytic);
            view(2)
            hold on
            plot(Point_B(:,1),Point_B(:,2),'k')
            hold off;
            colormap(jet)
            set(gca,'XDir','normal','FontSize',14)
            c=colorbar;
            c.Label.FontSize = 14;
            c.Label.String ='Cumulative Spike Number';
            set(gca,'XColor', 'none','YColor','none')
            set(gca, 'color', 'none');
            set(gca,'position',[0.0922401171303111 0.142933537051184 0.270131771595902 0.714132925897632])
            
            % Second subplot - Scatter plot with weighted locations over
            % the skin
            subplot(1,2,2)     
            plot(Point_B(:,1),Point_B(:,2),'k')
            hold on
            h(1)=scatter(Indentations(aux+1,1),Indentations(aux+1,3),130,"X", 'MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'LineWidth',1.5);
            legend('Targert','FontSize',14)
            hold on
            h(2)=scatter(Weighted_loc(1,1), Weighted_loc(1,3),130,"X", 'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'LineWidth',1.5);
            legend('Weighted Location','FontSize',14)
            hold on
            set(gca,'ColorOrderIndex',1,'FontSize',14)
            for k=1:21
                scatter(FBG_Sensors(k,1),FBG_Sensors(k,3),30, 'filled'),
                hold on
            end
            l=  legend(h(1:2), 'Targert', 'Weighted Location', 'location','northeastoutside');%, 'location','northeastoutside'
            % set(l,'visible','off')
            axis equal;
            box off
            %set(gca,'xdir','reverse')
            xlim([-55, 55])
            ylim([-2, 150])
            xlabel('x (mm)', 'FontSize',14)
            ylabel('y (mm)', 'FontSize',14)
            set(gca,'XColor', 'none','YColor','none')
            set(gca, 'color', 'none');
            set(gca,'position',[0.510248901903376 0.142933537051184 0.270131771595906 0.714132925897632])
            saveas (fig2, 'Fig 5', 'png')
            close
        end
    end
    Erro_Loc{j}=Erro;
    clearvars Erro
end
Ind = horzcat(TestIndx{1},TestIndx{2},TestIndx{3},TestIndx{4});

Erro = horzcat (Erro_Loc{1},Erro_Loc{2},Erro_Loc{3},Erro_Loc{4});
xind=(Indentations(Ind+1,1));
cind=(Indentations(Ind+1,2));
yind=(Indentations(Ind+1,3));
z_error_after=Erro';

%% Plot prediction error after synaptic learning as a function of location - Fig6-b

fig3=figure;
dt = delaunayTriangulation(xind,yind) ;
tri = dt.ConnectivityList ;
xi = dt.Points(:,1) ;
yi = dt.Points(:,2) ;

F = scatteredInterpolant(xind,yind,z_error_after);
zi = F(xi,yi) ;
trisurf(tri,xi,yi,zi)
shading interp
colormap(jet)
view(2)
hold on
plot(Point_B(:,1),Point_B(:,2),'k')
axis equal
ylabel('y (mm)')
xlabel('x (mm)')
zlabel("Prediction Error (mm)")
colorbar
axis equal
grid off
title('Prediction error of contact location')
saveas(fig3,'Fig 6-b','png')
close

%% Predicting localization error from data before synaptic learning
for j=1:4
    nSti=length(TestIndx{j});
    for i=1:nSti
        aux = TestIndx{j}((i));
        aux2=1;
        name=strcat('CN_Spike_Indentation_Before_', num2str(aux),'.mat');
        load(name)
        Nspks = sum(SpikesCN,3);
        for x=1:28
            for z=1:37
                Nspks2(aux2)=Nspks(z,x);
                aux2=aux2+1;
            end
        end
        
        Weighted_loc=(sum(Centroide.*Nspks2'))/sum(Nspks2); %  Calculate weighted location of spikes
        Erro_b(i)= sqrt((Indentations(aux+1,1)-Weighted_loc(1,1))^2+(Indentations(aux+1,3)-Weighted_loc(1,3))^2); % Calculate error between actual and estimated locations
        
    end
    
    Erro_Loc_b{j}=Erro_b;
    clearvars Erro_b
end
Erro_b = horzcat (Erro_Loc_b{1},Erro_Loc_b{2},Erro_Loc_b{3},Erro_Loc_b{4});
z_error_before=Erro_b';

%% Median and interquartile range values of the prediction error for different ROI radii
% aux1 and aux2 are used to xxpand the ROI radii
aux1=41;
aux2=42;
p = [25 50 75]; % Percentiles (25th, 50th, 75th)
load ('Skin_Area') % Load e-skin mesh area
for k=1:40
 aux=1;
        Z_after=0;
        Z_before=0;
    for i=1:length(z_error_after)
         % Check if the y and x coordinates fall within the current ROI
        if yind(i)>min(Zq(aux1,aux1:aux2)) && yind(i)<max(Zq(aux2,aux1:aux2)) && xind(i)<max(Xq(aux1:aux2,aux1)) && xind(i)>min(Xq(aux1:aux2,aux2))
             % Store the corresponding c, x, y, z_error_after, and z_error_before values
            Cc(aux)=cind(i); Xc(aux)=xind(i); Yc(aux)=yind(i); Z_after(aux)=z_error_after(i); Z_before(aux)=z_error_before(i);
            aux=aux+1;
        end
    end
    
    Area(k)=sum(sum(Area_square(aux1:aux2-1,aux1:aux2-1))); % Calculate the area of the current ROI
    % Expand the ROI by adjusting aux1 and aux2
    aux1=aux1-1;
    aux2=aux2+1;
    Pexact_After(k,:) = prctile(Z_after,p); % Calculate the percentiles (25th, 50th, 75th) of the prediction error after training
    Pexact_Before(k,:) = prctile(Z_before,p);  % Calculate the percentiles (25th, 50th, 75th) of the prediction error before training
    radius(k)=sqrt(Area(k)); % Calculate the radius of the ROI based on its area
end
radius=radius/2; % Calculate the radius of the ROI based on its area

%% Plot the median and interquartile range of the prediction error before and after synaptic learning for different ROI radii - Fig6-c
fig4 = figure;
p1=plot(radius(2:end),Pexact_After(2:end,2), 'Color', [0 0.4470 0.7410], 'LineWidth', 2.5);
hold on
x2 = [radius(2:end), fliplr(radius(2:end))];
inBetween = [Pexact_After(2:end,1)', fliplr(Pexact_After(2:end,3)')];
fill(x2, inBetween,  [0 0.4470 0.7410], 'FaceAlpha', 0.2 ,'LineStyle', 'none' );
p2=plot(radius(2:end),Pexact_Before(2:end,2), 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2.5);
hold on
x2 = [radius(2:end), fliplr(radius(2:end))];
inBetween = [Pexact_Before(2:end,1)', fliplr(Pexact_Before(2:end,3)')];
fill(x2, inBetween,  [0.8500 0.3250 0.0980], 'FaceAlpha', 0.2 ,'LineStyle', 'none' );
xlim([2.4 55])
ylim([0 60])
ylabel("Prediction Error (mm)")
xlabel('ROI Radius (mm)')
legend([p1 p2],{'After Synaptic Learning', 'Before Synaptic Learning'})

saveas (fig4, 'Fig 6-c', 'png')
close
