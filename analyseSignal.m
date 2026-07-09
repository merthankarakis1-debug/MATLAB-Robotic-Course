function [maximum, zeit_max] = analyseSignal(t, y)
[maximum, index]=max(y);
zeit_max = t(index);
end