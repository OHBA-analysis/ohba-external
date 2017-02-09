function [warpedim] = applyaffine(im,aff)
% [warpedim] = applyaffine(im,aff)
%
% Applies the affine transform (aff) to image im, producing a 
%  transformed image (warpedim)
% The affine matrix must be either 3x3 or 4x4 but always using
%   homogeneous coordinates  (the 4x4 describes a 3D transform)

warpedim = zeros(size(im));
[N,M] = size(im);

if size(aff) == [3,3],
 aff3 = aff;
elseif size(aff) == [4,4],
 aff3 = [ aff(1:2,1:2) aff(1:2,4) ; 0 0 1];
else
 error('Affine matrix is not 3x3 or 4x4');
end

x=kron(1:N,ones(M,1));
y=kron((1:M)',ones(1,N));
aff3=aff3-eye(3);

warp = zeros(N,M,2);
warp(:,:,1) = aff3(1,1)*x + aff3(1,2)*y + aff3(1,3);
warp(:,:,2) = aff3(2,1)*x + aff3(2,2)*y + aff3(2,3);

warpedim = applywarp(im,warp,x,y);
