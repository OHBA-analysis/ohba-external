function [d] = edim(a)
% EDIM   Returns the effective dimension of a variable
%    EDIM(A) returns the effective dimension of the variable A
%    That is, if A is 5x4x2 then it returns 3
%    However, if A is 5x1x2 then it returns 2
%    Similary, if A is 2x1 it returns 1 and if A is 1x1 it returns 0
%
%    See also DIM
nulldims = sum(size(a)==1);
d=length(size(a))-nulldims;
