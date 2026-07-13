function [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3)

% Punkt 0: Ursprung / Basis unten
p0 = [0; 0; 0];

% Punkt 1: Schulterpunkt oben auf der Basis
p1 = [0; 0; L1];

% Abstand in der horizontalen Ebene nach Arm 1
r2 = L2*cos(theta2);

% Höhe von Arm 1
z2 = L1 + L2*sin(theta2);

% Punkt 2: Ende von Arm 1
p2 = [r2*cos(theta1);
    r2*sin(theta1);
    z2];

% Gesamtwinkel für Arm 2
theta23 = theta2 + theta3;

% Abstand in horizontaler Ebene bis zur Spitze
r3 = L2*cos(theta2) + L3*cos(theta23);

% Höhe der Spitze
z3 = L1 + L2*sin(theta2) + L3*sin(theta23);

% Punkt 3: Greiferspitze
p3 = [r3*cos(theta1);
    r3*sin(theta1);
    z3];

end