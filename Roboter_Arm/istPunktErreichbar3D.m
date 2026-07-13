function erreichbar = istPunktErreichbar3D(L1, L2, L3, punkt)

x = punkt(1);
y = punkt(2);
z = punkt(3);

% Horizontaler Abstand
r = sqrt(x^2 + y^2);

% Höhe relativ zur Schulter
z_rel = z - L1;

% Abstand von Schulter zum Zielpunkt
d = sqrt(r^2 + z_rel^2);

% Erreichbarkeit prüfen
if d <= L2 + L3 && d >= abs(L2 - L3)
    erreichbar = true;
else
    erreichbar = false;
end

end