function glm_fit2(tseries, i, j, k, copenum)

% glm_fit(tseries, i, j, k)
%
% used by ViewFMRI in view_feat_results

global xs dm pes zs acs c;

cla;
hold on;

filter = establish_filter(squeeze(acs(i,j,k,:)),length(tseries));

if(std(filter)>0),
ts = prewhiten(detrend(tseries,0),filter);
%plot(ts);
pwdm = prewhiten(dm,filter);

ev = (c(1,:)*pinv(pwdm))';
for cn=2:4,
 ev = ev + (c(cn,:)*pinv(pwdm))';
end;

plot(real(fft(ts-ev)),'r')
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