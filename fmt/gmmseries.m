function gmmseries(tseries, i, j, k, varargin)

if(nargin>4)
n=varargin;
else
n=1;
end;

if std(tseries)<=0,return;end;

if(n>1)
fit_gmm2(tseries,n,1);
else,
mix = gmm(1, 1, 'spherical');
mix.centres = mean(tseries);
mix.covars = var(tseries);
plot_mm(mix,tseries,1);
end;

title(sprintf('Slice %d; X: %d  Y: %d',k,i,j)); 
