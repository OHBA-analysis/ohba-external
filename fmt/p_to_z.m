function z = p_to_z(p)

z = (2^0.5)*erfinv(1-2*p);
