function z=r_to_t_to_z(r,n);
% z=r_to_t_to_z(r,n);
% n is number of samples for estimation of r

t=r*sqrt(n-2)./sqrt(1-r.^2);
z=t_to_z(t,n-2);
