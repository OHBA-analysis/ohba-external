function ret = logbetafunctionnew(x,y,z,S)

   % want to do change of variable to get flat reference prior
   % x is log(var) 
   
   if(exp(x) < 0) ret =1e32; return; end;
   
   iU=diag(1./(S+exp(x)));
   ziUz=z'*iU*z;
   gam=inv(ziUz)*z'*iU*y;

   ret = -(0.5*log(det(iU))-0.5*log(det(ziUz))-0.5*(y'*iU*y-gam'*ziUz*gam));
