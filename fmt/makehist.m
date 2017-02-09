function [hist2] = makehist(im1,im2)
%  hist2 = makehist(im1,im2)
%
%  Makes a 2D joint histogram from images im1 and im2.
%  Uses as many entries as intensity values in each, so for
%   compact histograms preprocess the images so that only bin numbers are
%   used
%  Assumes both images have the same dimensions

[M,N]=size(im1);

min1 = floor(min(min(im1))) - 1;
min2 = floor(min(min(im2))) - 1;
hist2 = zeros(ceil(max(max(im1)))-min1, ceil(max(max(im2)))-min2);
for x1=1:M,
 for y1=1:N,
  hist2(round(im1(x1,y1))-min1,round(im2(x1,y1))-min2) = ...
    hist2(round(im1(x1,y1))-min1,round(im2(x1,y1))-min2) + 1;
 end
end
