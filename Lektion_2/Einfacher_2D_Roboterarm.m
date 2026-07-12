%Vorwärtskinematik

clear 
clc
close all

%Armlängen
L1 = 1.0;
L2 = 0.7;

%WInkel ind Grad
theta1_grad = -70;
theta2_grad = 20;

%Umrechnung in Radiant
theta1 = deg2rad(theta1_grad);
theta2 = deg2rad(theta2_grad);

%Position vom ersten Gelenkende
x1 = L1*cos(theta1);
y1 = L1*sin(theta1);

%Position von zweiten Gelenkende
x2 = x1 + L2*cos(theta2);
y2 = y1 + L2*sin(theta2);

% Plotten  
plot([0 x1 x2], [0 y1 y2], '-o','LineWidth',2,'MarkerSize',8) %Verbindung der 3 Punkte 
grid on
axis equal
xlabel('x')
ylabel('y')
title('2-Gelenk-Roboterarm')

disp('Position der Spitze')
disp([x2; y2])


