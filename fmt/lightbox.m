function lightbox(vol,opts)
% lightbox(vol) displays all slices of the volume vol as a lightbox
%  presentation
% lightbox(vol,num) displays lightbox and allows num points to be 
%  interrogated with the mouse (num=-1 gives unlimited number of
%  points; num=0 is default with no points )
% The interrogation can be terminated by a non-left button press or
%  a keyboard press *within the figure window*
% lightbox(vol,[num imin imax]) specifies the absolute intensity range
%  to use imin <= intensity <= imax.   This is useful for bypassing
%  the default robust range when it is inappropriate.
% lightbox(vol,[num 0]) calculates the absolute intensity range
%     short for lightbox(vol,[num min3(vol) max3(vol)]


if (nargin==1),
  num=0;
else
  num=opts(1);
end 

if ((nargin>1) & (length(opts)>=3)),
  irange = [opts(2) opts(3)];
elseif ((nargin>1) & (length(opts)==2)),
  % Use absolute range
  irange = [min(min3(vol)) max(max3(vol))];
else
  % Use the robust min and max
  irange = percentile(vol,[2 98]);
end

if ( abs(irange(2) - irange(1))==0),
  % Use absolute range if robust is no good
  irange = [min(min3(vol)) max(max3(vol))];
end
if ( abs(irange(2) - irange(1))==0),
  irange = [irange(1) irange(1)+1];
end


ioff = irange(1);
iscale = (length(colormap)-1)/(irange(2) - irange(1));

clf

sz = length(vol(1,1,:));
sz1=round(sqrt(sz));
sz2 = ceil(sz/sz1);


for y=1:sz1,
  for x=1:sz2,
    imno = x+(y-1)*sz2;
    if (imno<=sz),
      subplot(sz1,sz2,imno);
      image(max(min((vol(:,:,imno)-ioff)*iscale + 1,length(colormap)),1));
      axis off
    end
  end
end

getlboxvals(vol,num);

