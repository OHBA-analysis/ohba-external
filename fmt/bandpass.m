function [x freq_ind]=bandpass(y,freqrange,fres,do_plot,freq_ind)

% function x=bandpass(y,freqrange,fres,do_plot)
%
% does bandpass filtering via FFT

if(nargin<4)
  do_plot=0;
end;

Nsamples=length(y);

if(nargin<5 || (nargin>4 && isempty(freq_ind))),
    Nunique_points=ceil((Nsamples+1)/2);
    fHz = (0:Nunique_points-1)*fres/Nsamples;
    freq_ind=intersect(find(fHz>=freqrange(1)),find(fHz<=freqrange(2)));
end;

fy=fft(y);
fyo=fy(freq_ind);

x=convert_back_to_time(fyo, Nsamples, freq_ind);

if(do_plot), 
  Nunique_points=ceil((Nsamples+1)/2);
  fHz = (0:Nunique_points-1)*fres/Nsamples;
    
  fy2=zeros(size(fy));
  fy2(freq_ind)=fyo;
  figure;plot(fHz,abs(fy2(1:length(fHz))));
  figure;plot(x);ho;plot(y,'r--');
end;