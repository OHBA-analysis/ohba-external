function p = mvtpdf(t, m, C, v)

% p = mvtpdf(t, m, C, v)
%
% Type 1 multivariate t pdf
% t is vector for which the probability is to be calculated
% m is the mean vector
% C is the covariance matrix
% v is the dof

if(size(t,1) ~= length(C))
  t = t';
end;
if(size(m,1) == 1)
  m = m';
end;

k = length(m);

ts = t;

for i = 1:size(ts,2),
term = exp(gammaln((v + k) / 2) - gammaln(v/2));
p(i) = term ./ (sqrt(det(C))*(v*pi).^(k/2) .* (1 + (ts(i)-m)'*inv(C)*(ts(i)-m)/ v) .^ ((v + k)/2));
end;
