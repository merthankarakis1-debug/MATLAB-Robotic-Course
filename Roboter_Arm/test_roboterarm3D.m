


clear
clc
close all

% Armlängen
L1 = 0.2;   % Basis-Höhe
L2 = 0.4;   % Oberarm
L3 = 0.3;   % Unterarm

% Gelenkwinkel
theta1 = deg2rad(45);   % Basis dreht links/rechts
theta2 = deg2rad(30);   % Schulter hebt Arm
theta3 = deg2rad(-40);  % Ellbogen

% Positionen berechnen
[p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

% Koordinaten sammeln
X = [p0(1), p1(1), p2(1), p3(1)];
Y = [p0(2), p1(2), p2(2), p3(2)];
Z = [p0(3), p1(3), p2(3), p3(3)];

% Roboterarm plotten
figure
plot3(X, Y, Z, '-o', 'LineWidth', 3, 'MarkerSize', 8)
grid on
axis equal
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
title('3-Achsen-Roboterarm')

axis([-1 1 -1 1 0 1])

% Spitze anzeigen
disp('Greiferposition p3:')
disp(p3)