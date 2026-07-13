clear
clc
close all

% Armlängen
L1 = 0.2;
L2 = 0.4;
L3 = 0.3;

% Startwinkel
theta1_start = deg2rad(0);
theta2_start = deg2rad(20);
theta3_start = deg2rad(-30);

% Zielposition
x_ziel = 0.4;
y_ziel = 0.2;
z_ziel = 0.3;

% Inverse Kinematik berechnen
[theta1_ziel, theta2_ziel, theta3_ziel, erreichbar] = inverseKinematik3D(L1, L2, L3, x_ziel, y_ziel, z_ziel);

if erreichbar == false
    disp('Ziel ist nicht erreichbar.')
    return
end

figure

% Animation von Startwinkel zu Zielwinkel
for s = 0:0.02:1

    % Winkel interpolieren
    theta1 = theta1_start + s*(theta1_ziel - theta1_start);
    theta2 = theta2_start + s*(theta2_ziel - theta2_start);
    theta3 = theta3_start + s*(theta3_ziel - theta3_start);

    % Roboterposition berechnen
    [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

    % Punkte sammeln
    X = [p0(1), p1(1), p2(1), p3(1)];
    Y = [p0(2), p1(2), p2(2), p3(2)];
    Z = [p0(3), p1(3), p2(3), p3(3)];

    % Plot aktualisieren
    clf
    plot3(X, Y, Z, '-o', 'LineWidth', 3, 'MarkerSize', 8)
    hold on
    plot3(x_ziel, y_ziel, z_ziel, 'x', 'MarkerSize', 12, 'LineWidth', 3)
    hold off

    grid on
    axis equal
    xlabel('x [m]')
    ylabel('y [m]')
    zlabel('z [m]')
    title('3D-Roboterarm fährt zum Ziel')

    axis([-0.8 0.8 -0.8 0.8 0 0.8])
    view(45, 25)

    pause(0.03)
end

disp('Ziel erreicht.')
disp('Zielposition:')
disp([x_ziel; y_ziel; z_ziel])

disp('Endposition Greifer:')
disp(p3)

disp('Zielwinkel in Grad:')
disp(rad2deg([theta1_ziel; theta2_ziel; theta3_ziel]))