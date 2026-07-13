function objekt_liste = kameraSimulationMehrereObjekte(anzahl_objekte)

% Simulierte Kamera erkennt mehrere Objekte auf dem Tisch

x_min = 0.25;
x_max = 0.50;

y_min = -0.25;
y_max = 0.25;

z_tisch = 0.05;

objekt_liste = zeros(3, anzahl_objekte);

for i = 1:anzahl_objekte
    x = x_min + (x_max - x_min)*rand;
    y = y_min + (y_max - y_min)*rand;
    z = z_tisch;

    objekt_liste(:, i) = [x; y; z];
end

end