function [x,y,z]=hist2dsph(thph,n);
%HIST2DSPH -- 2D histogram of theta, phi round a sphere
%
%        [X,Y,Z]=HIST2DSPH(THPH,N);
%
%        THPH is Mx2 matrix of Theta and Phi
%
%        N is number of bins on each axis
%       
% Copyright (C) T.Behrens 2001


bin=hist2d(thph,n);
th=min(thph(:,1)):(max(thph(:,1))-min(thph(:,1)))/(n-1):max(thph(:,1));
ph=min(thph(:,2)):(max(thph(:,2))-min(thph(:,2)))/(n-1):max(thph(:,2));
x=sin(th')*cos(ph); y=sin(th')*sin(ph); z=cos(th')*ones(1,n);
x=x.*bin; y=y.*bin; z=z.*bin;
if nargout==0
  h=surf(x,y,z); set(h,'linestyle','none'); colormap([1 0 1]);
  light; lighting phong; axis equal;
end