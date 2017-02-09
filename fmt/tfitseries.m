function tfitseries(tseries, i, j, k, varargin)

if std(tseries)<=0,return;end;

[m, phi, v ] = tfit(tseries,20,1);

title(sprintf('Slice %d; X: %d  Y: %d v: %d',k,i,j,round(v))); 
