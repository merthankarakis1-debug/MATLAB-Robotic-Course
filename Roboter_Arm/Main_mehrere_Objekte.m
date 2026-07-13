clear
clc
close all

% =========================
% Roboter-Parameter
% =========================
L1 = 0.2;
L2 = 0.4;
L3 = 0.3;

theta = [deg2rad(0);
         deg2rad(30);
         deg2rad(-40)];

% =========================
% System-Parameter
% =========================
z_oben = 0.35;
greifer_zu = false;

box_pos = [0.35; -0.25; 0.05];

anzahl_objekte = 3;
objekt_liste = kameraSimulationMehrereObjekte(anzahl_objekte);

disp('Kamera hat folgende Objekte erkannt:')
disp(objekt_liste)

figure

% =========================
% Alle Objekte nacheinander bearbeiten
% =========================

for i = 1:anzahl_objekte

    objekt_pos = objekt_liste(:, i);

    disp(['Bearbeite Objekt ', num2str(i), ' von ', num2str(anzahl_objekte)])
    disp(objekt_pos)

    % Wegpunkte berechnen
    objekt_oben  = [objekt_pos(1); objekt_pos(2); z_oben];
    objekt_unten = objekt_pos;

    box_oben  = [box_pos(1); box_pos(2); z_oben];
    box_unten = box_pos;

    % Erreichbarkeit prüfen
    if istPunktErreichbar3D(L1, L2, L3, objekt_pos) == false
        disp('Objekt ist nicht erreichbar. Überspringe dieses Objekt.')
        continue
    end

    if istPunktErreichbar3D(L1, L2, L3, box_pos) == false
        disp('Box ist nicht erreichbar. Programm beendet.')
        return
    end

    % Start anzeigen
    ziel = objekt_oben;
    zeichneRoboter3D_MehrereObjekte(L1, L2, L3, theta, ziel, objekt_liste, i, box_pos, greifer_zu)
    pause(0.5)

    % 1. Über Objekt fahren
    disp('Fahre über Objekt...')
    ziel = objekt_oben;
    theta = fahreZuPunkt3D_MehrereObjekte(theta, ziel, L1, L2, L3, objekt_liste, i, box_pos, greifer_zu);

    % 2. Runter zum Objekt
    disp('Fahre runter zum Objekt...')
    ziel = objekt_unten;
    theta = fahreZuPunkt3D_MehrereObjekte(theta, ziel, L1, L2, L3, objekt_liste, i, box_pos, greifer_zu);

    % 3. Greifer schließen
    disp('Greifer schließt.')
    greifer_zu = true;
    zeichneRoboter3D_MehrereObjekte(L1, L2, L3, theta, ziel, objekt_liste, i, box_pos, greifer_zu)
    pause(0.8)

    % 4. Hochfahren mit Objekt
    disp('Fahre hoch mit Objekt...')
    ziel = objekt_oben;
    theta = fahreZuPunkt3D_MehrereObjekte(theta, ziel, L1, L2, L3, objekt_liste, i, box_pos, greifer_zu);

    % 5. Über Box fahren
    disp('Fahre über Box...')
    ziel = box_oben;
    theta = fahreZuPunkt3D_MehrereObjekte(theta, ziel, L1, L2, L3, objekt_liste, i, box_pos, greifer_zu);

    % 6. Runter zur Box
    disp('Fahre runter zur Box...')
    ziel = box_unten;
    theta = fahreZuPunkt3D_MehrereObjekte(theta, ziel, L1, L2, L3, objekt_liste, i, box_pos, greifer_zu);

    % 7. Greifer öffnen
    disp('Greifer öffnet.')
    greifer_zu = false;
    zeichneRoboter3D_MehrereObjekte(L1, L2, L3, theta, ziel, objekt_liste, i, box_pos, greifer_zu)
    pause(0.8)

    % 8. Wieder hochfahren
    disp('Fahre wieder hoch...')
    ziel = box_oben;
    theta = fahreZuPunkt3D_MehrereObjekte(theta, ziel, L1, L2, L3, objekt_liste, i, box_pos, greifer_zu);

end

disp('Alle erreichbaren Objekte wurden bearbeitet.')
disp('Endwinkel in Grad:')
disp(rad2deg(theta))