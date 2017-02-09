function ov(vol,centre,voxdims,opts)
% Calls orthoview

if (nargin>=4),
  orthoview(vol,centre,voxdims,opts);
elseif (nargin==3),
  orthoview(vol,centre,voxdims);
elseif (nargin==2),
  orthoview(vol,centre);
elseif (nargin==1),
  orthoview(vol);
end


