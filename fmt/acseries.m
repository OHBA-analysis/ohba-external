function acseries(tseries, i, j, k, varargin)

tseries = detrend(tseries,0);
ac = xcorr(tseries,20,'coeff');

plot(ac(ceil(end/2):end));

title(sprintf('Slice %d; X: %d  Y: %d',k,i,j)); 
