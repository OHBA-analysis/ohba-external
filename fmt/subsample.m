function [subim] = subsample(im)
% subim = subsample(im)
%
% Subsamples the image (im) by a factor of 2, with pre-blurring, and
%  returns the image as subim

[M,N] = size(im);
M2 = floor(M/2);
N2 = floor(N/2);
imblur = conv2(im,gauss(0.85,3),'same');
subim = zeros(M2,N2);
for x1=1:M2,
 for y1=1:N2,
  subim(x1,y1) = imblur(x1*2-1,y1*2-1);
 end
end
