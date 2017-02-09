function fftseries(tseries, i, j, k, varargin)

tseries = detrend(tseries,0);
ft = abs(fft(tseries));
plot(ft(1:ceil(length(tseries)/2)));

title(sprintf('Slice %d; X: %d  Y: %d',k,i,j)); 
