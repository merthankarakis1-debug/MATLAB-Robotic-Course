clear
clc
close all

% Armlängen
L1 = 0.2;
L2 = 0.4;
L3 = 0.3;

% Startwinkel
theta1 = deg2rad(0);
theta2 = deg2rad(20);
theta3 = deg2rad(-30);

% Startgeschwindigkeiten
omega1 = 0;
omega2 = 0;
omega3 = 0;

% Zielposition
x_ziel = 0.4;
y_ziel = 0.2;
z_ziel = 0.3;

% Zielwinkel über inverse Kinematik berechnen
[theta1_ziel, theta2_ziel, theta3_ziel, erreichbar] = inverseKinematik3D(L1, L2, L3, x_ziel, y_ziel, z_ziel);

if erreichbar == false
    disp('Ziel ist nicht erreichbar.')
    return
end

% Reglerparameter
Kp = 10;
Kd = 3;

dt = 0.03;
max_schritte = 500;
toleranz_winkel = deg2rad(1);
toleranz_omega = deg2rad(1);

figure

for schritt = 1:max_schritte

    % Fehler berechnen
    fehler1 = theta1_ziel - theta1;
    fehler2 = theta2_ziel - theta2;
    fehler3 = theta3_ziel - theta3;

    % PD-Regler: Beschleunigung berechnen
    alpha1 = Kp*fehler1 - Kd*omega1;
    alpha2 = Kp*fehler2 - Kd*omega2;
    alpha3 = Kp*fehler3 - Kd*omega3;

    % Geschwindigkeit aktualisieren
    omega1 = omega1 + alpha1*dt;
    omega2 = omega2 + alpha2*dt;
    omega3 = omega3 + alpha3*dt;

    % Winkel aktualisieren
    theta1 = theta1 + omega1*dt;
    theta2 = theta2 + omega2*dt;
    theta3 = theta3 + omega3*dt;

    % Roboterposition berechnen
    [p0, p1, p2, p3] = berechneRoboterarm3D(L1, L2, L3, theta1, theta2, theta3);

    X = [p0(1), p1(1), p2(1), p3(1)];
    Y = [p0(2), p1(2), p2(2), p3(2)];
    Z = [p0(3), p1(3), p2(3), p3(3)];

    % Plot
    clf
    plot3(X, Y, Z, '-o', 'LineWidth', 3, 'MarkerSize', 8)
    hold on
    plot3(x_ziel, y_ziel, z_ziel, 'x', 'MarkerSize', 12, 'LineWidth', 3)
    hold off

    grid on
    axis equal
    xlabel('x [m]')
    ylabel('y [m]')
    zlabel('z [m]')
    title('3D-Roboterarm mit PD-Regler')

    axis([-0.8 0.8 -0.8 0.8 0 0.8])
    view(45, 25)

    text(-0.75, -0.75, 0.75, ['Schritt: ', num2str(schritt)])
    text(-0.75, -0.75, 0.68, ['Fehler1: ', num2str(rad2deg(fehler1), '%.2f'), ' Grad'])
    text(-0.75, -0.75, 0.61, ['Fehler2: ', num2str(rad2deg(fehler2), '%.2f'), ' Grad'])
    text(-0.75, -0.75, 0.54, ['Fehler3: ', num2str(rad2deg(fehler3), '%.2f'), ' Grad'])

    pause(dt)

    % Stoppen, wenn Winkel und Geschwindigkeiten klein genug sind
    if abs(fehler1) < toleranz_winkel && abs(fehler2) < toleranz_winkel && abs(fehler3) < toleranz_winkel && ...
       abs(omega1) < toleranz_omega && abs(omega2) < toleranz_omega && abs(omega3) < toleranz_omega
        disp('Ziel erreicht mit PD-Regler.')
        break
    end
end

disp('Zielposition:')
disp([x_ziel; y_ziel; z_ziel])

disp('Endposition Greifer:')
disp(p3)

disp('Endwinkel in Grad:')
disp(rad2deg([theta1; theta2; theta3]))