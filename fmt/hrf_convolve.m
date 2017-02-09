function [x x_highres hrf t_hrf] = hrf_convolve(s, res, tr)

% [x x_highres hrf t] = hrf_convolve(s, res, tr)
% 
% s is the stimulus at high temporal resolution
% res is the high temporal resolution (in seconds) that the convolution will be performed at
% tr is in seconds

 s=s(:)';

 sigma1=2.449; my1=6; % first gamma
 sigma2=4; my2=14;    % second gamma
 
 alpha1=my1^2/sigma1^2;
 beta1=my1/sigma1^2;
 alpha2=my2^2/sigma2^2;
 beta2=my2/sigma2^2;
 
 ratio=6;
 
 num_secs=length(s)*res;
 t_hrf=[res:res:num_secs];
 hrf = gammapdf(alpha1,beta1,t_hrf) - gammapdf(alpha2,beta2,t_hrf)/ratio;
  
 hrf=hrf/max(hrf);
 
 x_highres = fftconv(s,hrf);
 
 x = demean(x_highres(tr/res:tr/res:end));
