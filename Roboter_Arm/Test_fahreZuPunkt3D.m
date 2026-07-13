clear
clc
close all

L1 = 0.2;
L2 = 0.4;
L3 = 0.3;

theta = [deg2rad(0);
    deg2rad(30);
    deg2rad(-40)];

ziel = [0.35; 0.20; 0.20];

theta = fahreZuPunkt3D(theta, ziel, L1, L2, L3);

[p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta(1), theta(2), theta(3));

X = [p0(1), p1(1), p2(1), p3(1)];
Y = [p0(2), p1(2), p2(2), p3(2)];
Z = [p0(3), p1(3), p2(3), p3(3)];

figure
plot3(X, Y, Z, '-o', 'LineWidth', 3, 'MarkerSize', 8)
hold on
plot3(ziel(1), ziel(2), ziel(3), 'x', 'MarkerSize', 12, 'LineWidth', 3)
hold off

grid on
axis equal
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
title('Test fahreZuPunkt3D')

axis([-0.8 0.8 -0.8 0.8 0 0.8])
view(45, 25)

disp('Ziel:')
disp(ziel)

disp('Greiferposition:')
disp(p3)

disp('Endwinkel in Grad:')
disp(rad2deg(theta))