function glm_fit(tseries, i, j, k, copenum, t_or_f)

% glm_fit(tseries, i, j, k)
%
% used by ViewFMRI in view_feat_results

global xs dm copes zs acs c fc;

cla;
hold on;

filter = establish_filter(squeeze(acs(i,j,k,:)),length(tseries));

if(std(filter)>0),
ts = prewhiten(detrend(tseries,0),filter);
plot(ts);
pwdm = prewhiten(dm,filter);

if(t_or_f=='f')
  j=1;
  for i=1:size(fc,2),
    if(fc(copenum,i))
      c1(j,:) = c(i,:);
      j=j+1;
    end;
  end;
else
  c1 = c(copenum,:);
end;

% get effective regressor(s) for contrast(s):
ev = (c1*pinv(pwdm))';
b = pinv(ev)*ts;
plot(ev*b,'r');
end;

title(sprintf('Slice %d; X: %d  Y: %d Zstat:4.2f',i,j,k,zs(i,j,k))); 

hold off;

%%%%%%%%%%

function y = prewhiten(x,filter)

n = size(x,1);
y = x;

for i = 1:size(x,2),
	zeropad = length(filter);
	fx = fft(squeeze(x(:,i)),zeropad);
	y2 = real(ifft(fx.*filter));
	y(:,i)=y2(1:n);
end;

%%%%%%%%%%%

function fy = establish_filter(ac,n)

zeropad = 2^nextpow2(n);
ac1 = zeros(zeropad,1);
ac1(1:length(ac)) = ac;
ac1(zeropad-length(ac)+2:zeropad) = fliplr(ac(2:length(ac)));

fac = fft(ac1,zeropad);

warning off;
fac = 1./fac;
warning on;

fac(1) = 0;
fy = fac/std(fac);