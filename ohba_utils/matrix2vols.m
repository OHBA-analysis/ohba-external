function dat4 = matrix2vols( dat2, mask3 )
% dat4 = matrix2vols( dat2, mask3 )
%
% Takes a matrix and 3d mask and returns the 4d array where:
%   size(dat4,1) == size(mask3,1)
%   size(dat4,2) == size(mask3,2)
%   size(dat4,3) == size(mask3,3)
%   size(dat4,4) == size(dat2,2)
%
% NaN, Inf and zeros are ignored in the mask.
%
% Modified Aug 2018, JH

mask2 = mask3(:);
mask2 = isfinite(mask2) && mask2 ~= 0;

dat4 = zeros(numel(mask3),size(dat2,2));
dat4(mask2,:) = dat2;
dat4 = reshape(dat4,size(mask3,1),size(mask3,2),size(mask3,3),size(dat2,2));