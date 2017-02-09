function imagesc(varargin)
% IMAGESC(...,im)
%
%   Displays the image (im) using the IMAGE command
%     but with a pre-scaling to scale the intensity
%     to fit the maximum range in the colormap
%   All initial arguements are passed directly to IMAGE

n = length(varargin);
if (n==0),
   error('Imagesc must have at least one arguement');
end
im = varargin{n};
mx=max(max(im));
mn=min(min(im));
image(varargin{1:(n-1)},(im-mn)/(mx-mn)*max(size(colormap)))
