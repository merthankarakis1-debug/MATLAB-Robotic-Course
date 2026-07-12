function [x1, y1, x2, y2] = calcrobotarm(L1, L2, theta1, theta2)
% Ende von Arm 1
x1 = L1*cos(theta1);
y1 = L1*sin(theta1);

% Spitze von Arm 2
x2 = x1 + L2*cos(theta1 + theta2);
y2 = y1 + L2*sin(theta1 + theta2);

end