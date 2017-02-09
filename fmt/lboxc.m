function lboxc(vol,opts)
% Displays a lightbox view in coronal (given an axial input)
%
% See also: lightbox

if (nargin>=2),
  lbox(flipdim(permute(vol,[3 1 2]),1),opts);
elseif (nargin==1),
  lbox(flipdim(permute(vol,[3 1 2]),1));
end


