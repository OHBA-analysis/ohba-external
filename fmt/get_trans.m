function [transmat] = get_trans(fname)
% [transmat] = get_trans(fname)
% Opens the file fname and returns the 4x4 transformation matrix
fid = fopen(fname);
rmat = fscanf(fid,'%f');
fclose(fid);
if (prod(size(rmat))==16),
  transmat=reshape(rmat,4,4).';
else
  transmat=[reshape(rmat,4,3).'; 0 0 0 1];
end
