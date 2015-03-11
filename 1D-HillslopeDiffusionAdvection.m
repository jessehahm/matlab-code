#Author: Jesse Hahm

clear all
close all

C = 5*10^-12;           %coefficient for distributed process, m^2 s^-1
C = C *60*60*24*365;    %to m^2/year
D = 5*10^-12;           %coefficient for slope length process, m s^-1
D = D *60*60*24*365;    %to m^2/year
timeStep = 10; %years                 
Z(1,:) = [2,2,2,2,2,2,2,2,2,2,2,1,0,0,0,0,0,0,0,0,0];   %elevation, m
delX = 0.5; % m
X = 0:delX:10;    %x-distance, m

for t = 1:20000/timeStep    %time
    for i = 2:20
        Z(t+1,i) = Z(t,i) + ((X(i)*D+C)*(Z(t,i+1)-2*Z(t,i)+Z(t,i-1))*timeStep/(delX)^2) + (D*(Z(t,i+1)-Z(t,i-1))*timeStep/(2*delX));
    end
    Z(t+1,1) = Z(t+1,2);  %left most boundary condition
    Z(t+1,21) = Z(t+1,20); %right most boundary condition
 %Z(t+1,1) = 2;  %left most boundary condition
  %  Z(t+1,21) = 0; %right most boundary condition

end
plot(X,Z(1,:),'k');
hold on
plot(X,Z(100,:),'g');
hold on
plot(X,Z(200,:),'y');
hold on
plot(X,Z(300,:),'r');
hold on
plot(X,Z(1000,:),'b');
plot(X,Z(2000,:),'k');

ylim([-.5,2.5]);
% Create xlabel
xlabel('Distance from divide (m)');

% Create ylabel
ylabel('Vertical height (m)');

nodeAtTopOfScarp = Z(2000,11)
interfluveCurvature = (Z(2000,2)-2*Z(2000,3)+Z(2000,4))/delX^2
interfluveErosion = Z(1,1)-Z(2000,1)
