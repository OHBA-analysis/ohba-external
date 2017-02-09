function cdata = clamp(data,imin,imax)
%  cdata = clamp(data,imin,imax)
% 
% Returns a clamped copy (cdata) of the input data (data) where
%  each value is clamped to lie between imin and imax

if (imax<imin),
  error('imax must be greater than or equal to imin');
end

mask0 = data<imin;
mask1 = data>imax;
cdata = (1-mask1).*(1-mask0).*data + imin*mask0 + imax*mask1;

