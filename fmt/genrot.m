function R=genrot(V,th);
%GENROT - generic rotation matrix - Matrix for 3D rotation about V
%through angle th.
%       R=GENROT(V,TH)
%
% Tim Behrens

if nargin~=2
  error('fool')
end
V = V/sqrt(sum(V.^2));
C = cos(th); S = sin(th);
x=V(1);y=V(2);z=V(3);

R=[x^2+C*(1-x^2) x*y*(1-C)-z*S z*x*(1-C)+y*S;
   x*y*(1-C)+z*S y^2+C*(1-y^2) y*z*(1-C)-x*S;
   z*x*(1-C)-y*S y*z*(1-C)+x*S z^2+C*(1-z^2)];


