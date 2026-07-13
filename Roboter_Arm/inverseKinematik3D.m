function [theta1, theta2, theta3, erreichbar] = inverseKinematik3D(L1, L2, L3, x, y, z)

% Basiswinkel: Drehung um die z-Achse
theta1 = atan2(y, x);

% Horizontaler Abstand vom Ursprung zum Ziel
r = sqrt(x^2 + y^2);

% Höhe relativ zum Schulterpunkt
z_rel = z - L1;

% Abstand von Schulter zum Zielpunkt
d = sqrt(r^2 + z_rel^2);

% Prüfen, ob Ziel erreichbar ist
if d > L2 + L3 || d < abs(L2 - L3)
    theta1 = NaN;
    theta2 = NaN;
    theta3 = NaN;
    erreichbar = false;
    return
end

erreichbar = true;

% Ellbogenwinkel über Kosinussatz
cos_theta3 = (d^2 - L2^2 - L3^2) / (2*L2*L3);

% Numerische Sicherheit
cos_theta3 = max(min(cos_theta3, 1), -1);

% Ellbogen nach unten / oben Variante
theta3 = -acos(cos_theta3);

% Hilfswinkel
alpha = atan2(z_rel, r);

beta = atan2(L3*sin(theta3), L2 + L3*cos(theta3));

% Schulterwinkel
theta2 = alpha - beta;

end