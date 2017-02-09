function val = gammapdf(a, b, x)

% function val = gammapdf(a, b, x)
%
% Evaluates a gamma of parameters a,b for all values in vector x
% Will have mean m and variance v: m = a/b; v = a/b^2;
% so, a = m^2/v; b = m/v;

% equation is   pow(l,h) * pow(x,h-1) * exp(-l*x - gammln)  but
% replace with more numerically sensible equivalent.

val = exp(a*log(b) + (a-1)*log(x) - b*x - gammaln(a));
