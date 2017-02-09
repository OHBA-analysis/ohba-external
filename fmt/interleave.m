function y= interleave(x1,x2)

if(length(x1)~=length(x2))
  display('x1 and x2 need to be the same length');
  return;
end;

y = zeros(1,length(x1*2));
y(1:2:length(x1)*2) = x1;
y(2:2:length(x2)*2) = x2;
