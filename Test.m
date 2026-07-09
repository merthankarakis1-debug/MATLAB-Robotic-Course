clear
clc
close all

t = 0:0.01:5;

y1 = sin(2*pi*t);
y2 = cos(2*pi*t);

plot(t, y1, t, y2)
grid on
xlabel('Zeit [s]')
ylabel('Signal')
title('Sinus und Cosinus')
legend('sin', 'cos')