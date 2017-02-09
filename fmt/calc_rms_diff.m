function [rms,angl,transl] = calc_rms_diff(tr1,tr2,max_r,centre)
%  [rms,angl,transl] = CALC_RMS_DIFF(tr1,tr2,max_r,centre)
%
%  Calculates the mean squared error between the two candidate
%   transformations (4x4 affine matrices)
%  Returns the rms error (rms), the angle difference (angl) and
%   the translational difference (transl)
%  The domains can be voxel domains (must be the same for both tr1 and tr2)
%   but the range must be measurement space (i.e. in mm)
%  Must specify the maximum radius (max_r), the centre of rotation (world coords)
%   and the measurement sampling (sr - a diagonal matrix)
%

[r,t,s,k]=decomp_aff(tr1*inv(tr2),centre);
angl=real(decomp_rot(r));
isodifft = tr1*inv(tr2) - eye(4);
dn=isodifft(1:3,1:3);
transl=isodifft(1:3,4) + dn*centre;
rms = sqrt( dot(transl,transl) + 1/5*max_r^2 * trace(dn.'*dn) );

