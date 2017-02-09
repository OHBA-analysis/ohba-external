function [m] = median3(x)
% performs median(reshape(x,prod(size(x)),1));

m = median(reshape(x,prod(size(x)),1));
