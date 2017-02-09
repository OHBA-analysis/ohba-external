function [beta] = cyclic2(alpha,p,q)
% function [beta] = cyclic2(alpha,p,q)
% Cyclic performs a cyclic shift of (p,q) on the data

beta=cyclic(alpha,q);
beta=cyclic(beta.',p).';
