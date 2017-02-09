function [angles] = decomp_rot(rotmat)
%  [angles] = DECOMP_ROT(rotmat)
%
%  Takes the 3x3 rotation matrix and returns the 
%   axis * angle (in radians)
%
rot=rotmat(1:3,1:3);
residual=sum(sum((rot*rot.' - eye(3)).^2));
residual=residual + sum(sum((rot.'*rot - eye(3)).^2));
if (residual>1e-4)
  disp(['WARNING: Failed orthogonality check (residual = ',num2str(residual),')']);
  disp('         Matrix is not strictly a rotation matrix');
  %return;
end
[v,d]=eig(rot);
[y,idx]=sort(real(diag(d)));
angles=abs(angle(d(idx(2),idx(2))))*v(:,idx(3));
