function ret=grad(func,x,h,varargin)

% ret=grad(func,x,h,varargin)
%
% numerically computes gradient of function func at values x with step size h

en=feval(func,x,varargin{:});
ret=zeros(length(en),length(x));

for i=1:length(x),
  xtmp=x;
  xtmp(i)=xtmp(i)+h;
  en_plus=feval(func,xtmp,varargin{:});  
  ret(:,i)=(en_plus-en)/h;
end;

if(0)
  en=feval(func,x,varargin{:});
  ret=zeros(length(en),length(x));
  
  for i=1:length(x),
  xtmp=x;
  xtmp(i)=xtmp(i)+h;
  en_plus=feval(func,xtmp,varargin{:});  

  xtmp=x;
  xtmp(i)=xtmp(i)-h;
  en_minus=feval(func,xtmp,varargin{:});  

  ret(:,i)=(en_plus-en_minus)/(2*h);
end;
end;