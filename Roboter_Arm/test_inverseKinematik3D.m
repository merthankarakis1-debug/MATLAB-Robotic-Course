clear
clc
close all

% Armlängen
L1 = 0.2;
L2 = 0.4;
L3 = 0.3;

% Zielposition
x_ziel = 0.6;
y_ziel = 0.0;
z_ziel = 0.0;

% Inverse Kinematik berechnen
[theta1, theta2, theta3, erreichbar] = inverseKinematik3D(L1, L2, L3, x_ziel, y_ziel, z_ziel);

if erreichbar == false
    disp('Ziel ist nicht erreichbar.')
    return
end

% Vorwärtskinematik mit berechneten Winkeln prüfen
[p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

% Punkte sammeln
X = [p0(1), p1(1), p2(1), p3(1)];
Y = [p0(2), p1(2), p2(2), p3(2)];
Z = [p0(3), p1(3), p2(3), p3(3)];

% Plot
figure
plot3(X, Y, Z, '-o', 'LineWidth', 3, 'MarkerSize', 8)
hold on
plot3(x_ziel, y_ziel, z_ziel, 'x', 'MarkerSize', 12, 'LineWidth', 3)
grid on
axis equal
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
title('Inverse Kinematik 3D')

axis([-0.8 0.8 -0.8 0.8 0 0.8])
view(45, 25)

% Werte anzeigen
disp('Zielposition:')
disp([x_ziel; y_ziel; z_ziel])

disp('Berechnete Greiferposition:')
disp(p3)

disp('Winkel in Grad:')
disp(rad2deg([theta1; theta2; theta3]))