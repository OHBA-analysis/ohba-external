function logbeta = solveforlogbetanew(beta0,y,z,S)

options=foptions;
%options(14) = 10;
logbeta = gslinemin('logbetafunctionnew',beta0,1,0,options,y,z,S);