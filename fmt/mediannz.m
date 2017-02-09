function [m] = mediannz(x)
% finds the median of all the non-zero entries
% will return the overall median regardless of object dimension (uses reshape)

nx=reshape(x,[prod(size(x)) 1]);
p = 100*(1 - 0.5*sum(nx~=0)/length(nx));
% Now set all zero elements to be less than the minimum value, and hence
%  at the start of the percentiles
nx = nx + (min(nx)-1)*(nx==0);
m = percentile(nx,p);
