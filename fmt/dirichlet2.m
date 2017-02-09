function pdf=dirichlet2(x,u);
% DIRICHLET2 - calculate the dirichlet pdf
%
%    PDF=DIRICHLET2(X,U);
%
%    X is vector of values. 0<X(i)<1 and
%    sum(X,1) = 1
%
%    U is vector of dirichlet parameters
%    0<U(i) and size(U)=[size(X,1) 1];
%
%    dirichlet pdf is ::
%
%    gamma(sum(U,1))/prod(gamma(U),1)*prod(X.^(U-1));
%    for each column of X 
%    (C) T.Behrens 2001
if(~isempty(find(x<=0)) | ~isempty(find(x>=1)))
  error(' X is out of range ')
elseif(~isempty(find(u<=0)))
  error(' U may not be negative or zero ')
elseif(size(u,1)~=size(x,1))
  error(' U must have the same no of rows as X ')
elseif(size(u,2)~=1)
  error(' U may only have one column - define different parameters in different rows of U')
end

u=repmat(u,1,size(x,2));
pdf=exp(gammaln(sum(u,1)) - sum(gammaln(u),1) + sum(log(x.^(u-1))));

