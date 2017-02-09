function h=line3(R);
% LINE3 - convenience to save typing LINE(R(:,1),R(:,2),R(:,3));
% 
% LINE3(R);
%
% H = LINE3(R);
%
% performs line above;
%
% TB

if(nargin~=1)
  error('Wrong Number of input arguments - Read the help!!')
end
if(nargout==0)
  line(R(:,1),R(:,2),R(:,3));
else 
  h=line(R(:,1),R(:,2),R(:,3));
end
