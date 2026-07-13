clear
clc
close all

% =========================
% Roboter-Parameter
% =========================
L1 = 0.2;
L2 = 0.4;
L3 = 0.3;

% Startwinkel als Vektor
theta = [deg2rad(0);
         deg2rad(30);
         deg2rad(-40)];

% =========================
% Objekt und Box
% =========================
objekt_pos = kameraSimulation();
box_pos    = [0.35; -0.25; 0.05];

disp('Kamera hat Objekt erkannt bei:')
disp(objekt_pos)

% Prüfen, ob Objekt erreichbar ist
if istPunktErreichbar3D(L1, L2, L3, objekt_pos) == false
    disp('Objekt ist nicht erreichbar. Programm wird beendet.')
    return
end

% Prüfen, ob Box erreichbar ist
if istPunktErreichbar3D(L1, L2, L3, box_pos) == false
    disp('Box ist nicht erreichbar. Programm wird beendet.')
    return
end

% Sicherheits-Höhe
z_oben = 0.35;

% Greiferstatus
greifer_zu = false;

% =========================
% Wegpunkte
% =========================

objekt_oben  = [objekt_pos(1); objekt_pos(2); z_oben];
objekt_unten = objekt_pos;

box_oben  = [box_pos(1); box_pos(2); z_oben];
box_unten = box_pos;

figure

% =========================
% Start anzeigen
% =========================
ziel = objekt_oben;
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(1)

% =========================
% 1. Über Objekt fahren
% =========================
disp('Fahre über Objekt...')
ziel = objekt_oben;
theta = fahreZuPunkt3D(theta, ziel, L1, L2, L3, objekt_pos, box_pos, greifer_zu);
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(0.5)

% =========================
% 2. Runter zum Objekt
% =========================
disp('Fahre runter zum Objekt...')
ziel = objekt_unten;
theta = fahreZuPunkt3D(theta, ziel, L1, L2, L3, objekt_pos, box_pos, greifer_zu);
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(0.5)

% =========================
% 3. Greifer schließen
% =========================
disp('Greifer schließt.')
greifer_zu = true;
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(0.8)

% =========================
% 4. Hochfahren mit Objekt
% =========================
disp('Fahre hoch mit Objekt...')
ziel = objekt_oben;
theta = fahreZuPunkt3D(theta, ziel, L1, L2, L3);
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(0.5)

% =========================
% 5. Über Box fahren
% =========================
disp('Fahre über Box...')
ziel = box_oben;
theta = fahreZuPunkt3D(theta, ziel, L1, L2, L3);
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(0.5)

% =========================
% 6. Runter zur Box
% =========================
disp('Fahre runter zur Box...')
ziel = box_unten;
theta = fahreZuPunkt3D(theta, ziel, L1, L2, L3);
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(0.5)

% =========================
% 7. Greifer öffnen
% =========================
disp('Greifer öffnet.')
greifer_zu = false;
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)
pause(0.8)

% =========================
% 8. Wieder hochfahren
% =========================
disp('Fahre wieder hoch...')
ziel = box_oben;
theta = fahreZuPunkt3D(theta, ziel, L1, L2, L3);
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)

disp('Pick-and-Place fertig.')
disp('Endwinkel in Grad:')
disp(rad2deg(theta))