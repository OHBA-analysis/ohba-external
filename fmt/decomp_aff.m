function [rotmat,transl,scales,skew] = decomp_aff(transmat,varargin)
% [rotmat,transl,scales,skew] = DECOMP_AFF(transmat,centre)
%
%  Takes the 4x4 transformation matrix and returns the 3x3 rotation 
%   matrix (rotmat), the 3x1 translation matrix (transl),
%   and the 4x4 matrixes for scaling (scales) and skew (skew)
%   such that:  transmat = [rotmat transl; 0 0 0 1]*skew*scales
%  Centre is an optional argument specifying the centre of the
%   rotation - this affects the translation  (default centre is [0 0 0])
%   with a non-zero centre : 
%      transmat = [rotmat transl + (eye(3)-rotmat)*centre; 0 0 0 1]*skew*scales
%
if (length(varargin)<1)
  centre=[0 0 0].';
else
  centre=varargin{1};
  csz=size(centre);
  if (csz(1)<csz(2)),
    centre=centre.';
  end
end
transl=transmat(1:3,4);
affmat=transmat(1:3,1:3);
x=affmat*[1;0;0];
y=affmat*[0;1;0];
z=affmat*[0;0;1];
sx=norm(x);
sy=sqrt(dot(y,y) - dot(x,y)^2/(sx^2));
a = dot(x,y)/(sx*sy);
x0=x/sx;
y0=y/sy - a*x0;
sz=sqrt(dot(z,z) - dot(x0,z)^2 - dot(y0,z)^2);
b = dot(x0,z)/sz;
c = dot(y0,z)/sz;
scales=diag([sx sy sz 1]);
skew=[1 a b 0; 0 1 c 0; 0 0 1 0; 0 0 0 1];
rotmat=affmat*inv(scales(1:3,1:3))*inv(skew(1:3,1:3));
transl=transl-(eye(3)-rotmat)*centre;
