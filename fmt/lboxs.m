function lboxs(vol,opts)
% Displays a lightbox view in sagittal (given an axial input)
%
% See also: lightbox

if (nargin>=2),
  lbox(flipdim(permute(vol,[3 2 1]),1),opts);
elseif (nargin==1),
  lbox(flipdim(permute(vol,[3 2 1]),1));
end


