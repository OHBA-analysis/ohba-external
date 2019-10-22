function dat2 = vols2matrix( dat4, mask )
% dat2 = vols2matrix(dat4,mask)
%
% Takes a 4d volume and mask and returns the 2d matrix where:
%   nrows == nnz(mask) (except Inf/NaN)
%   ncols == size(dat4,4);
%
% NaN, Inf and zeros are ignored in the mask.
%
% Modified Aug 2018, JH

assert( ndims(dat4) >= 3, 'First input should be 3 or 4D.' ); %#ok

mask = mask(:);
mask = isfinite(mask) & mask ~= 0;

dat2 = reshape( dat4, numel(mask), [] ); % this fails if mod( numel(dat4), numel(mask) ) ~= 0
dat2 = dat2(mask,:);

% Old version:
% mask=reshape(mask,prod(size(mask)),1)'>0;
% dat2=reshape(dat4,prod(size(mask)),size(dat4,4))';
% dat2=dat2(:,mask)';
