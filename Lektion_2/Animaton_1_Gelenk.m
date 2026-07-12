clear
clc
close all

% Armlängen
L1 = 1.0;
L2 = 0.7;

% Winkel für Gelenk 2 bleibt konstant
theta2_grad = 30;
theta2 = deg2rad(theta2_grad);

figure

% Gelenk 1 bewegt sich von 0 bis 180 Grad
for theta1_grad = 0:2:180

    % Grad in Radiant umrechnen
    theta1 = deg2rad(theta1_grad);

    % Roboterarm über eigene Funktion berechnen
    [x1, y1, x2, y2] = calcrobotarm(L1, L2, theta1, theta2);

    % Alten Plot löschen
    clf

    % Roboterarm zeichnen
    plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, 'MarkerSize', 8)

    grid on
    axis equal
    axis([-2 2 -2 2])
    xlabel('x')
    ylabel('y')
    title('Einfache Animation eines 2-Gelenk-Roboterarms')

    pause(0.03)
end