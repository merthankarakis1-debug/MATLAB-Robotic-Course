function zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)

% Winkel aus theta holen
theta1 = theta(1);
theta2 = theta(2);
theta3 = theta(3);

% Roboterpunkte berechnen
[p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

% Punkte für Arm
X = [p0(1), p1(1), p2(1), p3(1)];
Y = [p0(2), p1(2), p2(2), p3(2)];
Z = [p0(3), p1(3), p2(3), p3(3)];

% Greiferparameter
greifer_breite_offen = 0.08;
greifer_breite_zu = 0.03;
greifer_laenge = 0.08;

% Richtung des Greifers
theta23 = theta2 + theta3;

richtung = [cos(theta23)*cos(theta1);
            cos(theta23)*sin(theta1);
            sin(theta23)];

% Seitliche Richtung
seite = [-sin(theta1);
          cos(theta1);
          0];

% Greiferbreite abhängig vom Zustand
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

% Wenn Greifer zu ist, Objekt an Greifer anzeigen
if greifer_zu
    objekt_anzeige = p3;
else
    objekt_anzeige = objekt_pos;
end

% Plot
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

% Zielpunkt
plot3(ziel(1), ziel(2), ziel(3), ...
      'x', 'MarkerSize', 12, 'LineWidth', 3)

hold off

grid on
axis equal
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
title('3D Roboterarm Pick-and-Place')

axis([-0.8 0.8 -0.8 0.8 0 0.8])
view(45, 25)

if greifer_zu
    text(-0.75, -0.75, 0.75, 'Greifer: ZU')
else
    text(-0.75, -0.75, 0.75, 'Greifer: OFFEN')
end

drawnow

end
