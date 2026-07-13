function theta = fahreZuPunkt3D_ObjektStatus(theta, ziel, L1, L2, L3, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu)

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

for schritt = 1:max_schritte

    theta1 = theta(1);
    theta2 = theta(2);
    theta3 = theta(3);

    % Aktuelle Spitze
    [~, ~, ~, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

    % Positionsfehler
    fehler_pos = ziel - p3;
    abstand = norm(fehler_pos);

    if abstand < toleranz
        break
    end

    % Gewünschte Geschwindigkeit der Spitze
    v_ziel = Kp_pos * fehler_pos;

    if norm(v_ziel) > v_max
        v_ziel = v_ziel / norm(v_ziel) * v_max;
    end

    % Jacobi-Regler
    J = jacobiRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

    omega = J' * ((J*J' + lambda^2 * eye(3)) \ v_ziel);

    if norm(omega) > omega_max
        omega = omega / norm(omega) * omega_max;
    end

    % Winkel aktualisieren
    theta = theta + omega*dt;

    % Zeichnen
    zeichneRoboter3D_ObjektStatus(L1, L2, L3, theta, ziel, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu)

    pause(dt)
end

end