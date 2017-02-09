function [m] = meannz(x)
% finds the mean of all the non-zero entries
% will return the overall mean regardless of object dimension (uses reshape)

nx=reshape(x,[prod(size(x)) 1]);
m = sum(nx)/sum(nx~=0);
