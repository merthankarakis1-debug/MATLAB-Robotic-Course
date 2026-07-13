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

% Kamera erkennt mehrere Objekte
objekt_liste = kameraSimulationMehrereObjekte(anzahl_objekte);

% Status:
% 0 = liegt auf Tisch
% 1 = wird getragen
% 2 = ist in Box
objekt_status = zeros(1, anzahl_objekte);

% Ablagepositionen in der Box
box_ablage_liste = zeros(3, anzahl_objekte);

disp('Kamera hat folgende Objekte erkannt:')
disp(objekt_liste)

figure

% =========================
% Alle Objekte nacheinander bearbeiten
% =========================

for i = 1:anzahl_objekte

    aktives_objekt_index = i;
    objekt_pos = objekt_liste(:, i);

    disp(['Bearbeite Objekt ', num2str(i), ' von ', num2str(anzahl_objekte)])
    disp(objekt_pos)

    % Falls Objekt schon erledigt ist
    if objekt_status(i) == 2
        continue
    end

    % Wegpunkte
    objekt_oben  = [objekt_pos(1); objekt_pos(2); z_oben];
    objekt_unten = objekt_pos;

    % Jede Ablageposition leicht versetzen
    ablage_pos = box_pos + [0.00; 0.00; 0.03*(i-1)];

    box_oben  = [ablage_pos(1); ablage_pos(2); z_oben];
    box_unten = ablage_pos;

    % Erreichbarkeit prüfen
    if istPunktErreichbar3D(L1, L2, L3, objekt_pos) == false
        disp('Objekt ist nicht erreichbar. Überspringe dieses Objekt.')
        continue
    end

    if istPunktErreichbar3D(L1, L2, L3, box_unten) == false
        disp('Ablageposition ist nicht erreichbar. Überspringe dieses Objekt.')
        continue
    end

    % Start anzeigen
    ziel = objekt_oben;
    zeichneRoboter3D_ObjektStatus(L1, L2, L3, theta, ziel, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu)
    pause(0.5)

    % =========================
    % 1. Über Objekt fahren
    % =========================
    disp('Fahre über Objekt...')
    ziel = objekt_oben;
    theta = fahreZuPunkt3D_ObjektStatus(theta, ziel, L1, L2, L3, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu);

    % =========================
    % 2. Runter zum Objekt
    % =========================
    disp('Fahre runter zum Objekt...')
    ziel = objekt_unten;
    theta = fahreZuPunkt3D_ObjektStatus(theta, ziel, L1, L2, L3, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu);

    % =========================
    % 3. Greifer schließen
    % =========================
    disp('Greifer schließt.')
    greifer_zu = true;
    objekt_status(i) = 1;

    zeichneRoboter3D_ObjektStatus(L1, L2, L3, theta, ziel, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu)
    pause(0.8)

    % =========================
    % 4. Hochfahren mit Objekt
    % =========================
    disp('Fahre hoch mit Objekt...')
    ziel = objekt_oben;
    theta = fahreZuPunkt3D_ObjektStatus(theta, ziel, L1, L2, L3, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu);

    % =========================
    % 5. Über Box fahren
    % =========================
    disp('Fahre über Box...')
    ziel = box_oben;
    theta = fahreZuPunkt3D_ObjektStatus(theta, ziel, L1, L2, L3, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu);

    % =========================
    % 6. Runter zur Box
    % =========================
    disp('Fahre runter zur Box...')
    ziel = box_unten;
    theta = fahreZuPunkt3D_ObjektStatus(theta, ziel, L1, L2, L3, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu);

    % =========================
    % 7. Greifer öffnen / ablegen
    % =========================
    disp('Greifer öffnet. Objekt abgelegt.')
    greifer_zu = false;
    objekt_status(i) = 2;
    box_ablage_liste(:, i) = ablage_pos;

    zeichneRoboter3D_ObjektStatus(L1, L2, L3, theta, ziel, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu)
    pause(0.8)

    % =========================
    % 8. Wieder hochfahren
    % =========================
    disp('Fahre wieder hoch...')
    ziel = box_oben;
    theta = fahreZuPunkt3D_ObjektStatus(theta, ziel, L1, L2, L3, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu);

end

disp('Alle erreichbaren Objekte wurden bearbeitet.')
disp('Objektstatus:')
disp(objekt_status)

disp('Box-Ablagepositionen:')
disp(box_ablage_liste)

disp('Endwinkel in Grad:')
disp(rad2deg(theta))