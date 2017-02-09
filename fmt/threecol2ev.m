   function ev = threecol2ev(t,res,nsecs);
%THREECOL2EV convert 3col format to ev format.
% EV = THREECOL2EV(T,RES);
%
% RES is required temporal resolution
%
% T is the 3 column format
% 
% EV = THREECOL2EV(T,RES,NSECS);
%
% NSECS is the total length in seconds of your data.  
% If this argument is not included then total length 
% is set to the length of your three column ev
% 
% TB, HJB
if(nargin<2)
  error('Not enough input arguments')
end
t_res=t;
t_res(:,1:2)=round(t(:,1:2)/res)+1;


if(nargin==2) 
  ev = zeros(t_res(size(t_res,1),1)+t_res(size(t_res,1),2),1);
elseif(nargin==3)
  if(nsecs<(t(size(t,1),1)+t(size(t,1),2)))
      nsecs
      t(size(t,1),1)+t(size(t,1),2)
      %keyboard;
    error('Your three column ev is longer than nsecs')
  else
    ev = zeros(nsecs/res,1);
  end
end

%t_res(:,1)=t_res(:,1)+1-t_res(1,1);
for i=1:size(t_res,1)
  ev(t_res(i,1):t_res(i,1)+t_res(i,2))=t_res(i,3);
end
ev=ev(1:nsecs/res);
