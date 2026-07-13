function zeichneRoboter3D_ObjektStatus(L1, L2, L3, theta, ziel, objekt_liste, objekt_status, box_ablage_liste, aktives_objekt_index, box_pos, greifer_zu)

% Winkel aus theta holen
theta1 = theta(1);
theta2 = theta(2);
theta3 = theta(3);

% Roboterpunkte berechnen
[p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

% Roboterarm-Koordinaten
X = [p0(1), p1(1), p2(1), p3(1)];
Y = [p0(2), p1(2), p2(2), p3(2)];
Z = [p0(3), p1(3), p2(3), p3(3)];

% =========================
% Greifer berechnen
% =========================

greifer_breite_offen = 0.08;
greifer_breite_zu = 0.03;
greifer_laenge = 0.08;

theta23 = theta2 + theta3;

richtung = [cos(theta23)*cos(theta1);
            cos(theta23)*sin(theta1);
            sin(theta23)];

seite = [-sin(theta1);
          cos(theta1);
          0];

if greifer_zu
    greifer_breite = greifer_breite_zu;
else
    greifer_breite = greifer_breite_offen;
end

finger1_start = p3 + seite*(greifer_breite/2);
finger2_start = p3 - seite*(greifer_breite/2);

finger1_ende = finger1_start + richtung*greifer_laenge;
finger2_ende = finger2_start + richtung*greifer_laenge;

% =========================
% Plot
% =========================

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

% =========================
% Objekte zeichnen
% =========================

anzahl_objekte = size(objekt_liste, 2);

for k = 1:anzahl_objekte

    if objekt_status(k) == 0
        % Objekt liegt noch auf dem Tisch
        objekt = objekt_liste(:, k);

    elseif objekt_status(k) == 1
        % Objekt wird gerade getragen
        objekt = p3;

    elseif objekt_status(k) == 2
        % Objekt wurde in die Box gelegt
        objekt = box_ablage_liste(:, k);

    else
        continue
    end

    % Aktives Objekt größer zeichnen
    if k == aktives_objekt_index
        plot3(objekt(1), objekt(2), objekt(3), ...
              'ro', 'MarkerSize', 12, 'LineWidth', 3)
    else
        plot3(objekt(1), objekt(2), objekt(3), ...
              'ro', 'MarkerSize', 8, 'LineWidth', 2)
    end
end

% Box zeichnen
plot3(box_pos(1), box_pos(2), box_pos(3), ...
      'ks', 'MarkerSize', 14, 'LineWidth', 3)

% Zielpunkt zeichnen
plot3(ziel(1), ziel(2), ziel(3), ...
      'x', 'MarkerSize', 12, 'LineWidth', 3)

hold off

grid on
axis equal
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
title('Pick-and-Place mit Objektstatus und Box-Ablage')

axis([-0.8 0.8 -0.8 0.8 0 0.8])
view(45, 25)

% Text
if greifer_zu
    text(-0.75, -0.75, 0.75, 'Greifer: ZU')
else
    text(-0.75, -0.75, 0.75, 'Greifer: OFFEN')
end

text(-0.75, -0.75, 0.68, ['Aktives Objekt: ', num2str(aktives_objekt_index)])
text(-0.75, -0.75, 0.61, ['Status: ', num2str(objekt_status)])

drawnow

end