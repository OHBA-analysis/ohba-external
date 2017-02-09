function dg=digammaint(x,h)
% DIGAMMAINT - calculates digamma 0 of an integer
% 
% DG=DIGAMMA(X)
% DG=DIGAMMA(X,H)
% 
% evaluates gamma'(x)/gamma(x) using a numerical approximation 
% to the derivative. Step size in the numerical approximation is H
% (default 0.00001)
%
%        (C) T. Behrens 2002 
x=round(x);
for(i=1:length(x))
  dg(1,i) = digamma(1)+sum(1./(1:x(i)-1));
end