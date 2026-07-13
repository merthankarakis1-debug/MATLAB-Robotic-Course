clear
clc
close all

% =========================
% Roboter-Parameter
% =========================

% Armlängen
L1 = 0.2;   % Basis-Höhe
L2 = 0.4;   % Oberarm
L3 = 0.3;   % Unterarm

% Startwinkel
theta1 = deg2rad(0);
theta2 = deg2rad(30);
theta3 = deg2rad(-40);

% Reglerparameter
Kp_pos = 2.5;
dt = 0.03;
max_schritte = 800;
toleranz = 0.02;

% Begrenzungen
omega_max = deg2rad(90);
v_max = 0.5;

% Gedämpfte Pseudoinverse
lambda = 0.05;

% =========================
% Pick-and-Place Positionen
% =========================

% Objekt- und Boxposition
objekt_pos = [0.35; 0.20; 0.05];
box_pos    = [0.35; -0.25; 0.05];

% Sicherheits-/Anfahrhöhe
z_oben = 0.35;

% Greiferstatus
greifer_zu = false;

% Wegpunkte:
% 1. über Objekt
% 2. runter zum Objekt
% 3. hoch mit Objekt
% 4. über Box
% 5. runter zur Box
% 6. wieder hoch
wegpunkte = [
    objekt_pos(1), objekt_pos(2), z_oben;
    objekt_pos(1), objekt_pos(2), objekt_pos(3);
    objekt_pos(1), objekt_pos(2), z_oben;
    box_pos(1),    box_pos(2),    z_oben;
    box_pos(1),    box_pos(2),    box_pos(3);
    box_pos(1),    box_pos(2),    z_oben
];

figure

% =========================
% Hauptablauf
% =========================

for ziel_index = 1:size(wegpunkte, 1)

    ziel = wegpunkte(ziel_index, :)';

    % Greiferlogik
    % Nach Wegpunkt 2: Objekt greifen
    if ziel_index == 3
        greifer_zu = true;
        disp('Greifer schließt. Objekt aufgenommen.')
        pause(0.5)

    % Nach Wegpunkt 5: Objekt ablegen
    elseif ziel_index == 6
        greifer_zu = false;
        disp('Greifer öffnet. Objekt abgelegt.')
        pause(0.5)
    end

    for schritt = 1:max_schritte

        % =========================
        % Aktuelle Roboterposition
        % =========================

        [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

        % Positionsfehler
        fehler_pos = ziel - p3;
        abstand = norm(fehler_pos);

        % Ziel erreicht?
        if abstand < toleranz
            break
        end

        % =========================
        % Jacobi-Regler
        % =========================

        % gewünschte Spitzen-Geschwindigkeit
        v_ziel = Kp_pos * fehler_pos;

        % Geschwindigkeit der Spitze begrenzen
        if norm(v_ziel) > v_max
            v_ziel = v_ziel / norm(v_ziel) * v_max;
        end

        % Jacobi-Matrix
        J = jacobiRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

        % Gedämpfte Pseudoinverse
        omega = J' * ((J*J' + lambda^2 * eye(3)) \ v_ziel);

        % Gelenkgeschwindigkeit begrenzen
        if norm(omega) > omega_max
            omega = omega / norm(omega) * omega_max;
        end

        % Winkel aktualisieren
        theta1 = theta1 + omega(1)*dt;
        theta2 = theta2 + omega(2)*dt;
        theta3 = theta3 + omega(3)*dt;

        % Neue Roboterposition nach Bewegung
        [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

        % =========================
        % Objektposition anzeigen
        % =========================

        if greifer_zu
            % Wenn Greifer zu ist, hängt Objekt an der Spitze
            objekt_anzeige = p3;
        else
            % Sonst bleibt Objekt an Startposition
            objekt_anzeige = objekt_pos;
        end

        % =========================
        % Greifer berechnen
        % =========================

        greifer_breite_offen = 0.08;
        greifer_breite_zu = 0.03;
        greifer_laenge = 0.08;

        % Gesamtwinkel des letzten Armsegments
        theta23 = theta2 + theta3;

        % Richtung des Greifers / Unterarms
        richtung = [cos(theta23)*cos(theta1);
                    cos(theta23)*sin(theta1);
                    sin(theta23)];

        % Seitliche Richtung für zwei Finger
        seite = [-sin(theta1);
                  cos(theta1);
                  0];

        % Breite je nach Zustand
        if greifer_zu
            greifer_breite = greifer_breite_zu;
        else
            greifer_breite = greifer_breite_offen;
        end

        % Fingerpunkte
        finger1_start = p3 + seite*(greifer_breite/2);
        finger2_start = p3 - seite*(greifer_breite/2);

        finger1_ende = finger1_start + richtung*greifer_laenge;
        finger2_ende = finger2_start + richtung*greifer_laenge;

        % =========================
        % Plot vorbereiten
        % =========================

        X = [p0(1), p1(1), p2(1), p3(1)];
        Y = [p0(2), p1(2), p2(2), p3(2)];
        Z = [p0(3), p1(3), p2(3), p3(3)];

        clf

        % Roboterarm
        plot3(X, Y, Z, '-o', 'LineWidth', 3, 'MarkerSize', 8)
        hold on

        % Greiferfinger
        plot3([finger1_start(1), finger1_ende(1)], ...
              [finger1_start(2), finger1_ende(2)], ...
              [finger1_start(3), finger1_ende(3)], ...
              'LineWidth', 3)

        plot3([finger2_start(1), finger2_ende(1)], ...
              [finger2_start(2), finger2_ende(2)], ...
              [finger2_start(3), finger2_ende(3)], ...
              'LineWidth', 3)

        % Objekt
        plot3(objekt_anzeige(1), objekt_anzeige(2), objekt_anzeige(3), ...
              'ro', 'MarkerSize', 10, 'LineWidth', 3)

        % Box
        plot3(box_pos(1), box_pos(2), box_pos(3), ...
              'ks', 'MarkerSize', 14, 'LineWidth', 3)

        % aktuelles Ziel
        plot3(ziel(1), ziel(2), ziel(3), ...
              'x', 'MarkerSize', 12, 'LineWidth', 3)

        hold off

        grid on
        axis equal
        xlabel('x [m]')
        ylabel('y [m]')
        zlabel('z [m]')
        title('3D Pick-and-Place mit Jacobi-Regler und Greifer')

        axis([-0.8 0.8 -0.8 0.8 0 0.8])
        view(45, 25)

        % Textinformationen
        text(-0.75, -0.75, 0.75, ['Wegpunkt: ', num2str(ziel_index), ' / ', num2str(size(wegpunkte,1))])
        text(-0.75, -0.75, 0.68, ['Abstand: ', num2str(abstand, '%.3f'), ' m'])

        if greifer_zu
            text(-0.75, -0.75, 0.61, 'Greifer: ZU')
        else
            text(-0.75, -0.75, 0.61, 'Greifer: OFFEN')
        end

        text(-0.75, -0.75, 0.54, ['omega1: ', num2str(rad2deg(omega(1)), '%.1f'), ' Grad/s'])
        text(-0.75, -0.75, 0.47, ['omega2: ', num2str(rad2deg(omega(2)), '%.1f'), ' Grad/s'])
        text(-0.75, -0.75, 0.40, ['omega3: ', num2str(rad2deg(omega(3)), '%.1f'), ' Grad/s'])

        pause(dt)
    end
end

disp('Pick-and-Place Ablauf beendet.')

disp('Endwinkel in Grad:')
disp(rad2deg([theta1; theta2; theta3]))