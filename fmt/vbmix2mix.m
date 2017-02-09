function mix = vbmix2mix(vbmix)

% mix = vbmix2mix(vbmix)
%
% converts Tim's dodgey Gaussian mixture struct to the
% proper Netlab struct.

mix = gmm(1,vbmix.ncentres,'spherical');
mix.priors = vbmix.mixers.lambda/sum(vbmix.mixers.lambda);
mix.centres = vbmix.centres.means';
mix.covars = 1./(vbmix.precs.b.*vbmix.precs.c);