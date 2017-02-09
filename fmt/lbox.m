function lbox(vol,opts)
% Calls lightbox

if (nargin>=2),
  lightbox(vol,opts);
elseif (nargin==1),
  lightbox(vol);
end


