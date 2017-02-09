function imsc = scaleim(im)
% imsc = scaleim(im)
% 
% Returns a scaled version of the image, with intensities between 0 and 255

imsc = min(255,(im - min(min(im)))/(max(max(im)) - min(min(im))) * 256);

% Use the robust min and max
irange = percentile(im,[2 98]);
ioff = irange(1);
iscale = 255/(irange(2) - irange(1) + 1);

imsc = clamp((im - ioff)*iscale, 0,255);

