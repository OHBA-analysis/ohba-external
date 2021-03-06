function [transmat] = read_mri_xfm(fname)
% [transmat] = READ_MRI_XFM(fname)
%
%  Extracts the 4x4 transformation matrix
%   from a .xfm file generated by minctracc (via mritotal)
%

fid=fopen(fname);
while (~feof(fid)),
  str=fscanf(fid,'%s',1);
  if (strcmp(str,'Linear_Transform')),
    transmat=get_matrix(fid);
  end
end
fclose(fid);
return;


%-----------------------------------------

function g = get_matrix(fid)

str1 = fscanf(fid,'%s',1);
if (~strcmp(str1,'=')),
 disp('Error in reading Linear_Transform matrix');
end
 g = fscanf(fid,'%f',12);
 g = reshape(g,1,12);
 g = [g 0 0 0 1];
 g=reshape(g,4,4).';
return;
