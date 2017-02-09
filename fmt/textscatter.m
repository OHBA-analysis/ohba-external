function textscatter(a,b,style);
% TEXTSCATTER(A,B,STYLE)
%
% puts the index numbers next to the points in a scatter plot
% A,B are the 2 vectors
% Style is the third argument to plot - e.g 'ro'
%
% (C) Cedric - 2002

if(length(a)~=length(b))
     error('bugger off')
end
if(nargin<3)
     style='ro';
end
hold on
for i=1:length(a)
     h=plot(a(i),b(i),style);
     A=get(h);
     text(A.XData+0.03,A.YData,num2str(i))
end
