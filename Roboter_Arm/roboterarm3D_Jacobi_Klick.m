clear
clc
close all

% Armlängen
L1 = 0.2;
L2 = 0.4;
L3 = 0.3;

% Startwinkel
theta1 = deg2rad(0);
theta2 = deg2rad(30);
theta3 = deg2rad(-40);

% Reglerparameter
Kp_pos = 2.0;        % zieht die Spitze zum Ziel
dt = 0.03;           % Zeitschritt
max_schritte = 800;  % Sicherheitsgrenze
toleranz = 0.02;     % 2 cm Abstand erlaubt

% feste Zielhöhe
z_ziel = 0.3;

% Geschwindigkeit begrenzen
omega_max = deg2rad(90);
v_max = 0.5;

figure

while true

    % aktuelle Roboterposition berechnen
    [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

    X = [p0(1), p1(1), p2(1), p3(1)];
    Y = [p0(2), p1(2), p2(2), p3(2)];
    Z = [p0(3), p1(3), p2(3), p3(3)];

    % Roboter zeichnen
    clf
    plot3(X, Y, Z, '-o', 'LineWidth', 3, 'MarkerSize', 8)
    hold on

    % Klick-Ebene anzeigen
    plot3([-0.7 0.7 0.7 -0.7 -0.7], ...
          [-0.7 -0.7 0.7 0.7 -0.7], ...
          [z_ziel z_ziel z_ziel z_ziel z_ziel], '--')

    hold off
    grid on
    axis equal
    xlabel('x [m]')
    ylabel('y [m]')
    zlabel('z [m]')
    title('Klicke Zielpunkt in x-y. z ist fest.')
    axis([-0.8 0.8 -0.8 0.8 0 0.8])
    view(45, 25)

    text(-0.75, -0.75, 0.75, 'Linksklick = Ziel, Enter/Rechtsklick = Ende')

    % Wichtig: Für ginput besser Draufsicht verwenden
    view(2)
    xlabel('x [m]')
    ylabel('y [m]')
    title('Draufsicht: Klicke Zielpunkt für x/y')

    try
        [x_ziel, y_ziel, button] = ginput(1);
    catch
        disp('Figure wurde geschlossen. Programm beendet.')
        break
    end

    if isempty(button) || button ~= 1
        break
    end

    % Ziel anzeigen und Bewegung starten
    for schritt = 1:max_schritte

        % aktuelle Position berechnen
        [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

        % Positionsfehler der Spitze
        ziel = [x_ziel; y_ziel; z_ziel];
        fehler_pos = ziel - p3;

        % Abstand zum Ziel
        abstand = norm(fehler_pos);

        % Wenn nah genug: stoppen
        if abstand < toleranz
            disp('Ziel erreicht mit Jacobi-Regler.')
            break
        end

        % gewünschte Geschwindigkeit der Spitze
        v_ziel = Kp_pos * fehler_pos;

        % Geschwindigkeit begrenzen
        if norm(v_ziel) > v_max
            v_ziel = v_ziel / norm(v_ziel) * v_max;
        end

        % Jacobi-Matrix berechnen
        J = jacobiRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

        % Gedämpfte Pseudoinverse
        lambda = 0.05;
        omega = J' * ((J*J' + lambda^2 * eye(3)) \ v_ziel);

        % Gelenkgeschwindigkeit begrenzen
        if norm(omega) > omega_max
            omega = omega / norm(omega) * omega_max;
        end

        % Winkel aktualisieren
        theta1 = theta1 + omega(1)*dt;
        theta2 = theta2 + omega(2)*dt;
        theta3 = theta3 + omega(3)*dt;

        % neue Roboterposition berechnen
        [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

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
        title('3D-Roboterarm mit Jacobi-Regler')

        axis([-0.8 0.8 -0.8 0.8 0 0.8])
        view(45, 25)

        text(-0.75, -0.75, 0.75, ['Abstand: ', num2str(abstand, '%.3f'), ' m'])
        text(-0.75, -0.75, 0.68, ['omega1: ', num2str(rad2deg(omega(1)), '%.1f'), ' Grad/s'])
        text(-0.75, -0.75, 0.61, ['omega2: ', num2str(rad2deg(omega(2)), '%.1f'), ' Grad/s'])
        text(-0.75, -0.75, 0.54, ['omega3: ', num2str(rad2deg(omega(3)), '%.1f'), ' Grad/s'])
        text(-0.75, -0.75, 0.47, ['Schritt: ', num2str(schritt)])

        pause(dt)
    end

    disp('Aktuelle Greiferposition:')
    disp(p3)

    disp('Aktuelle Winkel in Grad:')
    disp(rad2deg([theta1; theta2; theta3]))

end