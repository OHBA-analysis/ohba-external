function [d] = dim(a)
% DIM   Returns the dimension of a variable
%    DIM(A) returns the dimension of the variable A
%    Note that this is the dimension of the MATLAB variable, not
%    its effective dimension.
%
%    See also EDIM
d=length(size(a));
