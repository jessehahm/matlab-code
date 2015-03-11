%Author: Jesse Hahm

clear all
close all

C = 5*10^-12;           %coefficient for rainsplash, m^2 s^-1
C = C *60*60*24*365;      %to m^2/year
timeStep = 100; %years                 
Z(1,:) = [2,2,2,2,2,2,2,2,2,2,2,1,0,0,0,0,0,0,0,0,0];   %elevation, m
delX = 0.5; % m
X = 0:delX:10;    %x-distance, m

for t = 1:10000/timeStep    %time, centuries
    for i = 2:20
        Z(t+1,i) = Z(t,i)+(C*timeStep/(delX^2))*(Z(t,i+1)-2*Z(t,i)+Z(t,i-1));
    end
    Z(t+1,1) = 2;  %left most boundary condition
    Z(t+1,21) = 0; %right most boundary condition
end
plot(X,Z(1,:),'k');
hold on
plot(X,Z(10,:),'g');
hold on
plot(X,Z(20,:),'y');
hold on
plot(X,Z(30,:),'r');
hold on
plot(X,Z(100,:),'b');
Z(100,:)

