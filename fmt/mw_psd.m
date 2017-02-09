function [psdx fHz]=mw_psd(x,Fs)

% function [ft fHz]=mw_psd(y,fres)
%

N = length(x);
xdft = fft(x);
xdft = xdft(1:round(N/2)+1);
psdx = (1/(Fs*N)).*abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
fres=Fs/length(x);
fHz = 0:fres:fres*(length(psdx)-1);