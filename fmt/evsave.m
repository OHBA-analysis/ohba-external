function evsave(fname,ev);
% EVSAVE saves ev to text.
% 
% EVSAVE(fname,ev);
% 
% FNAME is filename 
%
% EV is ev variable
%
% HJB
if(nargin<2)
  error('Not enough input arguments.')
end

fid=fopen(fname,'w');
if(fid==-1)
  error('Cannot write file')
else
  fprintf(fid,'%12.8f\n',ev);
  fclose(fid);
end

  
