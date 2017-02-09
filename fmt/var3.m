function [v] = var3(x)
% performs mean3((x - mean3(x)).^2);

v = mean3((x - mean3(x)).^2);
