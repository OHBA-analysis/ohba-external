function orthoview(vol,centre,voxdim,opts)
% orthoview(vol) displays orthogonal views (sagittal, coronal and axial) of
%  a volume, using the centre of the volume as the point included in all views
% orthoview(vol,centre) as above but allows the user to specify the centre
%  coordinate (i.e. centre must of the form [x y z] in voxels)
% orthoview(vol,centre,[imin imax]) as above but specifies the absolute 
%  intensity range to use imin <= intensity <= imax.   
%  This is useful for bypassing the default robust range when it is 
%  inappropriate.

if ((nargin>1) & (length(centre)>=3)),
  cvox=centre;
else
  cvox = round(size(vol)/2);
end

if ((nargin>2) & (length(voxdim)>=3)),
  vdims = abs(voxdim);
  vdims = vdims + (vdims==0)*1;  % get rid of zero dimensions
else
  vdims = [1 1 1];
end

if ((nargin>3) & (length(opts)>=2)),
  irange = [opts(1) opts(2)];
elseif ((nargin>3) & (length(opts)==1)),
  % Use absolute range
  irange = [min(min3(vol)) max(max3(vol))];
else
  % Use the robust min and max
  irange = percentile(vol,[2 98]);
end

if ( abs(irange(2) - irange(1))==0),
  % Use absolute range if robust is no good
  irange = [min(min3(vol)) max(max3(vol))];
end
if ( abs(irange(2) - irange(1))==0),
  irange = [irange(1) irange(1)+1];
end

ioff = irange(1);
iscale = (length(colormap)-1)/(irange(2) - irange(1));

clf

% Sagittal
subplot(2,2,1)
sagim = flipdim(permute(squeeze(vol(cvox(1),:,:)),[2 1]),1);
image(max(min((sagim-ioff)*iscale + 1,length(colormap)),1));
pbaspect([vdims(3) vdims(2) 1]);
axis off

% Coronal
subplot(2,2,2)
corim = flipdim(permute(squeeze(vol(:,cvox(2),:)),[2 1]),1);
image(max(min((corim-ioff)*iscale + 1,length(colormap)),1));
pbaspect([vdims(3) vdims(1) 1]);
axis off

% Axial
subplot(2,2,4)
axim = flipdim(permute(squeeze(vol(:,:,cvox(3))),[2 1]),1);
image(max(min((axim-ioff)*iscale + 1,length(colormap)),1));
pbaspect([vdims(2) vdims(1) 1]);
axis off

