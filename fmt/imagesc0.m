function imagesc0(varargin)
% IMAGESC0(...,im)
%
%   Displays the image (im) using the IMAGE command
%     but with a pre-scaling to scale the intensity
%     to fit the maximum range in the colormap with
%     the value zero ALWAYS being the middle of the
%     colormap
%   All initial arguements are passed directly to IMAGE

n = length(varargin);
if (n==0),
   error('Imagesc must have at least one arguement');
end
im = varargin{n};
mx=max(max(im));
mn=min(min(im));
me=mean(mean(im));
sc=max(abs(mx-me),abs(mn-me));
image(varargin{1:(n-1)},((im-me)/sc + 1)*0.5*max(size(colormap)))
axis off
