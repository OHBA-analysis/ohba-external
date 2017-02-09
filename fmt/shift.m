function [beta] = shift(alpha,n)

%  [beta] = shift(alpha,n)
%
%  performs a non-cyclic shift on the data by n values
%  see cyclic

m=length(alpha);

if(n<=0),
     beta=[alpha(-n+1:m); zeros(-n,1)];
end;

if(n>=0),
     beta=[zeros(n,1); alpha(1:m-n)];
end;

