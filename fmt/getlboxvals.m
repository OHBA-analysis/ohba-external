function getlboxvals(vol,num)
% getlboxvals(vol,num) allows num individual coordinates and intensities to be
%  found from a lightbox plot

sx = length(vol(:,1,1));
sy = length(vol(1,:,1));
sz = length(vol(1,1,:));
sz1=round(sqrt(sz));
sz2 = ceil(sz/sz1);

if (num>=0),
  count=1;
else
  count=num-1;
end

button = 1;
while ((button<=1) & (count<=num)),
  [xp,yp,button] = ginput(1);
  xc = round(xp);
  yc = round(yp);
  axh = gca;

  if ( (xc>0) & (yc>0) & (xc<=sx) & (yc<=sy) ),
    for y=1:sz1,
      for x=1:sz2,
	imno = x+(y-1)*sz2;
	subplot(sz1,sz2,imno);
	if (imno<=sz),
	  if (axh==gca),
	    disp(['X Y Z ; I = ',num2str(round(yp)),' ', ...
		  num2str(round(xp)),' ', ...
		  num2str(imno),' ; ',num2str(vol(round(yp),round(xp),imno))]);
	  end
	end
      end
    end
  end
  if (num>=0),
    count=count+1;
  end
end

