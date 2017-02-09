function [rotmat] = make_rot(angl,centre)
% [rotmat] = make_rot(angl,centre)
% Creates a 4x4 rotation matrix suitable for combination with the
%  affine transformations returned by MEDx
% angl should be a 3-vector representing the axis of rotation and
%  with length equal to the angle of rotation (in radians)
% centre should be the 3D coordinate of the centre for the rotation

if (norm(angl)==0),
  rotmat=eye(4);
  return;
end
ax=angl/norm(angl);
sz=size(ax);
if (sz(1)==3),
  ax=ax.';
end
x1=ax;
x2=[-ax(2),ax(1),0];
if (norm(x2)==0),
  x2=[1 0 0];
end
x3=cross(x1,x2);
x2=x2/norm(x2);
x3=x3/norm(x3);
tx=[x2; x3; x1];
th=norm(angl);
r=[cos(th) sin(th) 0; -sin(th) cos(th) 0; 0 0 1];
rot=tx.'*r*tx;
sz=size(centre);
if (sz(2)==3),
  centre=centre.';
end
trans=(eye(3)-rot)*centre;
rotmat=[rot, trans; 0 0 0 1]; 
