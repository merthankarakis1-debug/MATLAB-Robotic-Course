function y = gedampfterSinus(t, d)
y = sin(t) .* exp(-d*t);
end