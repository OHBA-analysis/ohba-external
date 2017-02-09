function [warpedim] = applywarp(im,warp,x,y)
% [warpedim] = applywarp(im,warp,x,y)
%
% Applies the warping field (warp) to image im, producing a new
%  warped image
% The warp field must be size [N,M,2] where warp(:,:,1) is the
%  warp in x, and warp(:,:,2) is the warp in y
% The additional arguments, x and y, must give the z and y coordinates
%  (respectively) at each pixel : they need to be the same size as im

warpedim = zeros(size(im));
[N,M] = size(im);

wx = round(x + warp(:,:,1)); 
wx=min(max(wx,1),N);
wy = round(y + warp(:,:,2)); 
wy=min(max(wy,1),M);

for x1=1:N,              
 for y1=1:M,
	% Note that wy and wx are opposite to fit with rows and columns!
  warpedim(x1,y1) = im(wy(x1,y1),wx(x1,y1)); 
 end
end
