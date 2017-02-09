function znew = orthoganalise(z,y,w)

% znew = orthoganalise(z,y,w)
%
% Orthoganalise z wrt y
% Orthoganalise ev no. y wrt ev. nos. w contained in design matrix z

if(nargin <3),
    znew = z-y*pinv(y)*z;
else,
    flip = 0;
   
    if(size(z,1)<size(z,2))
        z=z';
        flip=1;
    end;

    tmpy = z(:,y);
    tmpw=[];
    
    for i=1:length(w),
      tmpw = [tmpw, z(:,w(i))];    
    end;
    
   % keyboard;
    
    tmpynew = tmpy-tmpw*pinv(tmpw)*tmpy;
    znew = z;
    znew(:,y) = tmpynew;
    
    if(flip==1),
      znew=znew';
    end;
    
end;

