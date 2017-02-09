function ret = logsigg2function(x,y,z,sigbetak)

   % want to do change of variable to get flat reference prior
   % x is log(var) 
   
   if(isnan(exp(x)) || (exp(x) <= 0)) ret =1e32; return; end;
   
   Vi=sigbetak.^2+exp(x);

   iU=diag(1./(Vi));
%keyboard;
   ziUz=z'*iU*z;
   
   gam=pinv(ziUz)*z'*iU*y;

   ret = -(0.5*log(det(iU))-0.5*log(det(ziUz))-0.5*(y'*iU*y-gam'*ziUz*gam));
