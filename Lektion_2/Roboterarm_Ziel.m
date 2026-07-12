clear
clc
close all

% Armlängen
L1 = 1.0;
L2 = 0.7;

% Startwinkel
theta1 = deg2rad(30);
theta2 = deg2rad(30);

% Startposition berechnen
[x1, y1, x2, y2] = calcrobotarm(L1, L2, theta1, theta2);

figure

while true

    clf %lösch alten Plot

    % Roboterarm zeichnen
    plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, 'MarkerSize', 8)
    hold on

    % Arbeitsbereich zeichnen
    viscircles([0 0], L1 + L2, 'LineStyle', '--');

    grid on
    axis equal
    axis([-2 2 -2 2])
    xlabel('x')
    ylabel('y')
    title('Klick ein Ziel für die Roboterarm-Spitze')

    text(-1.9, 1.8, 'Klicke ein Ziel. Rechtsklick/Enter zum Beenden.')

    hold off

    % Zielpunkt mit Maus auswählen
    try
    [x_ziel, y_ziel, button] = ginput(1);
catch
    disp('Figure wurde geschlossen. Programm beendet.')
    break
end

    % Falls nicht links geklickt wurde: beenden
    if isempty(button) || button ~= 1
        break
    end

    % Inverse Kinematik berechnen
    [theta1_ziel, theta2_ziel, erreichbar] = inverseKinematik2D(L1, L2, x_ziel, y_ziel);

    if erreichbar == false
        disp('Ziel ist nicht erreichbar.')
        continue
    end

    % Bewegung animieren
    theta1_start = theta1;
    theta2_start = theta2;

    for s = 0:0.05:1 %zunächst mit Interpolation, danach jetzt mit P Regler

        theta1 = theta1_start + s*(theta1_ziel - theta1_start);
        theta2 = theta2_start + s*(theta2_ziel - theta2_start);

        [x1, y1, x2, y2] = calcrobotarm(L1, L2, theta1, theta2);

        clf

        plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, 'MarkerSize', 8)
        hold on
        plot(x_ziel, y_ziel, 'x', 'MarkerSize', 10, 'LineWidth', 2)
        viscircles([0 0], L1 + L2, 'LineStyle', '--');
        hold off

        grid on
        axis equal
        axis([-2 2 -2 2])
        xlabel('x')
        ylabel('y')
        title('Roboterarm fährt zum Ziel')

        pause(0.003)
    end

    % Endwinkel speichern
    theta1 = theta1_ziel;
    theta2 = theta2_ziel;

    disp('Ziel erreicht.')
    disp('theta1 in Grad:')
    disp(rad2deg(theta1))

    disp('theta2 in Grad:')
    disp(rad2deg(theta2))

end