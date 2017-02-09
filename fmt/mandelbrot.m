function varargout=mandelbrot(varargin)
% MANDELBROT - Calculate mandelbrot set.
% 
%  MANDELBROT(A) - display the set. A is a measure of resolution
%  (default 500).
% 
%  [C] = MANDELBROT(A) - C is output.
%
% TB 2002


if(nargin>2)
  error('Too many input arguments to MANDELBROT')
elseif(nargout>1)
  error('Too many output arguments to MANDELBROT')
end

if nargin==0
  a=500;
elseif nargin ==1
  a=varargin{1};
  plane='mu';
else
  a=varargin{1};
  plane=varargin{2};
end

A=zeros(2*a+1,3*a+1);
C=zeros(2*a+1,3*a+1);
creal=repmat((-2*a:a)/a,2*a+1,1);
cimag=repmat(sqrt(-1)/a*[-a:a]',1,3*a+1);
c=creal+cimag;
for k=1:32
  if(strcmp(plane,'mu'))
    A=A.^2+c;
  elseif(strcmp(plane,'invmu'))
    warning off;
    A=A.^2+1./c;
  elseif(strcmp(plane,'invmu2'));
    warning off
    A=A.^2-1./(c+0.25);
  else
    error('No such plane');
  end
  
    B=abs(A)>4&C==0;
  C=C+k*B;
end

if(nargout==0)
  image([-2*a:a]/a,[-a:a]/a,C);axis image;axis xy;
else
  varargout{1}=C;
end


