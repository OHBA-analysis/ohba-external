function [cmap,img]=imgoverlay(imga,imgb,cmap1,cmap2);
% IMGOVERLAY - overlay a thresholded image (imgb) on a background (imga)
%
% [cmap,img] = imgoverlay(imga,imgb);
%
% [cmap,img] = imgoverlay(imga,imgb,cmap1);
%
% e.g imgoverlay(imga,imgb,'bone') - background will be bone 
%
% [cmap,img] = imgoverlay(imga,imgb,cmap1,cmap2);
%
% e.g imgoverlay(imga,imgb,'bone','hot') - background bone,
% overlay hot.
% 
% To display - use image or lbox. 
% e.g 
% 
% image(img(:,:,slice_no));colormap(cmap);
%
% lbox(img);colormap(cmap);
%
% orthoview doesn't seem to work - 
% I think MJ does some kind of robust range finding
% 
% TB (2002)
%

if(nargin<2)
  error('Not enough Input arguments');
elseif(~(prod(double(size(imga)==size(imgb)))==1))
  error('Images must be same size -- dickhead');
end

if(nargin<4)
  cmap2='hot';
end
if(nargin<3)
  cmap1='bone';
end
figure;
colormap(cmap1);
c1=colormap;
c1=c1(1:2:end,:);
colormap(cmap2);
c2=colormap;
c2=c2(1:2:end,:);
close;
cmap=[c1;c2];

imgasc=(imga-min3(imga))/range(squash(imga))*32;
imgasc(find(imgb>0))=32;
imgbsc=(imgb-min3(imgb))/range(squash(imgb))*32;
img=imgasc+imgbsc;




