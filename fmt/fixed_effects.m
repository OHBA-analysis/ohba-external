function [gam, covgam] = fixed_effects(y,z,S)

% [gam, covgam] = fixed_effects(y,z,S)
%
% solves GLM y=z*gam+e where e~N(0, S) using 
% 
% y should be T x 1
% z should be T x num_regressors
% S should be TxT
%
% MWW

Sigma=pinv(S);

ztiU=z'*Sigma;

covgam = pinv(ztiU*z);

gam = covgam*ztiU*y;
