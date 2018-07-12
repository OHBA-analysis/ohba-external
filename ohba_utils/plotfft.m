function [ft fHz]=plotfft(y,fres)

% function [ft fHz]=plotfft(y,fres)
%

y=y(:)';

Nsamples=length(y);

Nunique_points=ceil((Nsamples+1)/2);

fHz = (0:Nunique_points-1)*fres/Nsamples;

fy=fft(y.*hanning(length(y))');

ft=abs(fy(1:length(fHz)));
