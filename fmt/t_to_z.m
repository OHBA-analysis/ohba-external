function z = t_to_z(t, dof);

% z = t_to_z(t, dof);
   
z = sign(t)*(2^0.5)*erfinv(1-2*tdist(abs(t),dof));

