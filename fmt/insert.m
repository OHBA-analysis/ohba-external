function [MatA]=insert(MatA,MatB,dim,num)
% INSERT - insert rows or columns into a sorted matrix
%
% MATC = INSERT(MATA,MATB,DIM,NUM);
%
% MATA - matrix into which rows or cols are to be inserted
%
% MATB - rows or cols to be inserted
%
% DIM - 1 for rows, 2 for cols
%
% NUM row or column number according to which MATA is sorted
%
% MATC - Output;
%
% TB

if(dim==2)
  MatA=MatA';
  MatB=MatB';
elseif(dim~=1)
  error('Invalid value for dim - must be 1 or 2');
end

for i=1:size(MatB,1)
  I=find(MatA(:,num)<MatB(i,num));
  if(isempty(I))
    MatA=[MatB(i,:);MatA];
  elseif(length(I)==size(MatA,1));
    MatA=[MatA;MatB(i,:)];
  else
  MatA=[MatA(I,:);MatB(i,:);MatA(I(end)+1:end,:)];
  end
end

if(dim==2)
  MatA=MatA';
  MatB=MatB';
end
