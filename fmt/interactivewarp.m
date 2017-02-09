function [warpedim] = interactivewarp(im,smooth)
% [warpedim] = interactivewarp(im,smooth)
%
% Allows the user to specify points, with the mouse, to push and pull
%  the image around
% The optional smoothing factor specifies how smooth the warps will
%  be with 1.0 (the default) being reasonably smooth
% Stops when the return key is pressed

if (nargin<2),
  smooth=1.0;
end

[N,M] = size(im);
warp = zeros(N,M,2);
warp2 = warp;
warpedim = im;
x = kron(1:M,ones(N,1));
y = kron((1:N).',ones(1,M));

imagesc(im);

while 2>1 , 
  undo = 0;

  c=1;
  while c<=2,
   [gx,gy,button]=ginput(1);
   if (length(gx)~=1),
    c=-1;
    break;
   end
 
   if (button==3),
    if (undo==0),
      warp2 = warp;
      undo = 1;
    else
      warp2 = zeros(size(warp));
    end
    warpedim = applywarp(im,warp2,x,y);
    imagesc(warpedim);
    c=0;
   end
 
   if (button==2),
    smooth=input('Enter new smoothing factor: ');
    c=0;
   end
 
   if c>=1,
     mx(c) = gx;  my(c) = gy;
   end
   c=c+1;
  end

  warp = warp2;

  if c==-1,
   break;
  end

  sig = smooth*norm([mx(1)-mx(2) , my(1)-my(2)]);
  sig=max(sig,0.0001);
  damp = exp(-(x-mx(2)).^2/(sig.^2)).*exp(-(y-my(2)).^2/(sig.^2));
  warp2(:,:,1) = warp(:,:,1) + (mx(1)-mx(2))*damp;
  warp2(:,:,2) = warp(:,:,2) + (my(1)-my(2))*damp;

  warpedim = applywarp(im,warp2,x,y);
  imagesc(warpedim);

end

% final smoothing
smoothfilter = ones(3,3);
smoothfilter(2,2) = 2;
smoothfilter = smoothfilter/sum(sum(smoothfilter));
warp(:,:,1) = conv2(warp2(:,:,1),smoothfilter,'same');
warp(:,:,2) = conv2(warp2(:,:,2),smoothfilter,'same');

% Return warpedim
warpedim = applywarp(im,warp,x,y);
imagesc(warpedim);
