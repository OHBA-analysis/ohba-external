function p = tdist(t,v)

% p = tdist(t,v)

p = betainc(v./(v+t.^2),v/2,1/2)/2;
