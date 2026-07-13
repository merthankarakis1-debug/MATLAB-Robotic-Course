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
objekt_pos = [0.35; 0.20; 0.05];
box_pos = [0.35; -0.25; 0.05];

greifer_zu = false;

figure
zeichneRoboter3D(L1, L2, L3, theta, ziel, objekt_pos, box_pos, greifer_zu)