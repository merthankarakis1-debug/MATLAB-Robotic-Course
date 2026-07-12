function [theta1, theta2, erreichbar] = inverseKinematik2D(L1, L2, x, y)

% Abstand vom Ursprung zum Zielpunkt
r = sqrt(x^2 + y^2);

% Prüfen, ob der Punkt erreichbar ist
if r > L1 + L2 || r < abs(L1 - L2)
    theta1 = NaN;
    theta2 = NaN;
    erreichbar = false;
    return
end

erreichbar = true;

% Winkel theta2 über Kosinussatz
cos_theta2 = (x^2 + y^2 - L1^2 - L2^2) / (2*L1*L2);

% Numerische Sicherheit
cos_theta2 = max(min(cos_theta2, 1), -1);

theta2 = acos(cos_theta2);

% Winkel theta1 berechnen
k1 = L1 + L2*cos(theta2);
k2 = L2*sin(theta2);

theta1 = atan2(y, x) - atan2(k2, k1);

end
