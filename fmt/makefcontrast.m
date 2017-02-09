function fc = makefcontrast(fccoded, tc, fcopenum)
   
% fc = makefcontrast(fccoded, tc, fcopenum)
%
% makes an f contrast matrix for the f contrast no. fcopenum
% from a t contrast matrix and a fccoded 
% matrix, which informs which t contrasts make up each f contrast

   j=1;
   for i=1:size(fccoded,2),
      if(fccoded(fcopenum,i))
	 fc(j,:) = tc(i,:);
	 j=j+1;
      end;
   end;
