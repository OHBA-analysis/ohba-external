function [beta] = cyclic(alpha,n)
%  [beta] = cyclic(alpha,n)
%  Cyclic performs a cyclic shift on the data by n values

n=-n;
m=length(alpha(1,:));
if n<0,
	n=n+m;
end
beta=[alpha(:,n+1:m) alpha(:,1:n)];
