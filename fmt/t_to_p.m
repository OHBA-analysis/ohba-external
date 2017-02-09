function p = t_to_p(t,v)

% p = t_to_p(t,v)
   
p = betainc(v./(v+t.^2),v/2,1/2)/2;
