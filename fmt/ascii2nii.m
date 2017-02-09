function ascii2nii(ascii_filename, nii_filename, tr)

% ascii2nii(ascii_filename, nii_filename, tr)
%
% converts an ascii text file to niftii file
% tr is in seconds

if(nargin<3)
  tr=3;
end;

x=load(ascii_filename);
x=reshape(x,1,1,1,length(x));
save_avw(x, nii_filename, 'f', [4 4 4 tr]);