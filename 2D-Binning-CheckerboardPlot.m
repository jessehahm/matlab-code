#Author: Jesse Hahm

clear all
close all
clf

%% Read In Data  - code considers values in first column to be the x values of interest!!!
delimiterIn = ',';
headerlinesIn = 1;
filename=['DataTables\sjk_noglac_all_noflats_ints_NumericOnly_nobadMAP','.txt'];
file = importdata(filename, delimiterIn, headerlinesIn);
xColumn = 9;
yColumn = 7;
xAxis = file.textdata(1,xColumn);
yAxis = file.textdata(1,yColumn);
%% Establish # of bins
%nX = round(sqrt(length(file.data)));
num = length(file.data);
nX = 20;
nY = 20; 
%% Determine Bin Width and Midpoints
% Determine Bin Width
binWidthX = ((max(file.data(:,xColumn))-min(file.data(:,xColumn)))/nX);
binWidthY = ((max(file.data(:,yColumn))-min(file.data(:,yColumn)))/nY);
%binWidthY = 0.5;
% Determine first (or minimum) bin midpoint
binMinMidptX = min(file.data(:,xColumn))+binWidthX/2;
binMinMidptY = min(file.data(:,yColumn))+binWidthY/2;
%binMinMidptY = 400;
% Populate 1xn double array of bin midpoints
for i = 0:nX-1
binMdptsX(i+1) = (binMinMidptX + binWidthX*i);
end
for i = 0:nY-1
binMdptsY(i+1) = (binMinMidptY + binWidthY*i);

end

%% Bin assignment of each x and y value in 'bin' matrix
bin(:,1) = ceil((file.data(:,xColumn)-min(file.data(:,xColumn)))/binWidthX);
bin(:,2) = ceil((file.data(:,yColumn)-min(file.data(:,yColumn)))/binWidthY);
%Deal with exceptional left endpoint case
for i = 1:length(file.data)
if bin(i,1) == 0
    bin(i,1) =  1;
end
if bin(i,2) == 0
    bin(i,2) =  1;
end
end

%% Create matrix (numInBin) of number of points in each bin. nX by nY matrix
for i = 1:nX %cycles through bins
    for j = 1:nY    
    index=((bin(:,1)==i) & (bin(:,2)==j)); %creates index matrix for current bin. 1 if in current bin, 0 if false
        numInBin(j,i) = sum(index(:,1)); %Add all the 1s for the current bin
    
   %Create 3 column table with binMidptsX, binMidptsY, # of values in bin
    xyzTable((i-1)*nY+j,1) = binMdptsX(i);
    xyzTable((i-1)*nY+j,2) = binMdptsY(j);
    xyzTable((i-1)*nY+j,3) = numInBin(j,i);
    end
end
%% Plot Histogram (x = bin midpoints of x, y = bin midpoints of y, z = # in bin)
for i = 0:nX-1
binPlotPtsX(i+1) = (min(file.data(:,xColumn)) + binWidthX*i);
end
for i = 0:nY-1
binPlotPtsY(i+1) = (min(file.data(:,yColumn)) + binWidthY*i);

end

%scatter3(xyzTable(:,1),xyzTable(:,2),xyzTable(:,3))
%figure(2)
 
% imagesc(binMdptsX,binMdptsY,numInBin)

% set(gca,'YDir','normal')

% string = 'Count in Bin';


% 




figure1 = figure('Colormap',...
    [1 1 1;0.857142865657806 0.857142865657806 1;0.714285731315613 0.714285731315613 1;0.571428596973419 0.571428596973419 1;0.428571432828903 0.428571432828903 1;0.28571429848671 0.28571429848671 1;0.142857149243355 0.142857149243355 1;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 0.9375;0.125 1 0.875;0.1875 1 0.8125;0.25 1 0.75;0.3125 1 0.6875;0.375 1 0.625;0.4375 1 0.5625;0.5 1 0.5;0.5625 1 0.4375;0.625 1 0.375;0.6875 1 0.3125;0.75 1 0.25;0.8125 1 0.1875;0.875 1 0.125;0.9375 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0;0.5 0 0],...
    'Color',[0.800000011920929 0.800000011920929 0.800000011920929]);

axes1 = axes('Parent',figure1,'CLim',[0 128913]);

h = pcolor(binPlotPtsX,binPlotPtsY,numInBin)
 xlabel(xAxis,'fontsize',7,'FontName','Arial');
 ylabel(yAxis,'fontsize',7,'FontName','Arial');
zlabel('Count in Bin','fontsize',7,'FontName','Arial');
set(h,'EdgeColor','none');

xlim(axes1,[200 3000]);
ylim(axes1,[0 100]);

colorbar('peer',axes1);

box(axes1,'off');
%hold(axes1,'all');
grid off
