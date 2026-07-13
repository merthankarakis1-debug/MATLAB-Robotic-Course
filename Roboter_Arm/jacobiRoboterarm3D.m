function J = jacobiRoboterarm3D(L1, L2, L3, theta1, theta2, theta3)

% Gesamtwinkel von Arm 2
theta23 = theta2 + theta3;

% Horizontaler Abstand der Greiferspitze
r = L2*cos(theta2) + L3*cos(theta23);

% Ableitungen von r
dr_dtheta2 = -L2*sin(theta2) - L3*sin(theta23);
dr_dtheta3 = -L3*sin(theta23);

% Ableitungen von z
dz_dtheta2 = L2*cos(theta2) + L3*cos(theta23);
dz_dtheta3 = L3*cos(theta23);

% Jacobi-Matrix
J = [ -r*sin(theta1),  dr_dtheta2*cos(theta1),  dr_dtheta3*cos(theta1);
    r*cos(theta1),  dr_dtheta2*sin(theta1),  dr_dtheta3*sin(theta1);
    0,              dz_dtheta2,              dz_dtheta3 ];

end