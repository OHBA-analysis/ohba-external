function histseries(tseries, i, j, k, numbins)

if(nargin < 5) numbins =sqrt(length(tseries)); end;
      
hist(tseries,numbins);

title(sprintf('Slice %d; X: %d  Y: %d',k,i,j)); 
