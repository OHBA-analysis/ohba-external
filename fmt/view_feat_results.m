function view_feat_results(featdir, copenum, t_or_f, zimg)

% view_feat_results(featdir, c)
%
% featdir is the feat directory.
% runs ViewFMRI using glm_fit 
% to show univariate analysis
% z-statistics and model fit for
% t-contrast number c.
%
% view_feat_results(featdir, c, t_or_f)
%
% shows model fit for the:
% t-contrast number c if t_or_f = 't'
% f-contrast number c if t_or_f = 'f'
%
% view_feat_results(featdir, c, t_or_f, zimg) 
%
% if zimg = 0 shows clustered and rendered zstats
% if zimg = 1 shows univariate analysis zstats

global xs dm copes zs acs c fc;

if (nargin <4) zimg=1; end;
if (nargin <3) t_or_f='t'; end;

statsdir = strcat(featdir,'/stats');
xs = read_avw(sprintf('%s/filtered_func_data', featdir));

if zimg==1,
  if(strcmp(t_or_f,'f'))
    zs = read_avw(sprintf('%s/zfstat%d', statsdir,copenum));
  else
    zs = read_avw(sprintf('%s/zstat%d', statsdir,copenum));
  end;
else,
  if(strcmp(t_or_f,'f'))
    zs = read_avw(sprintf('%s/Rendered_thresh_zfstat%d', ...
			      featdir,copenum));
  else
    zs = read_avw(sprintf('%s/Rendered_thresh_zstat%d', ...
			  featdir,copenum));
  end;
end;

copes = read_avw(sprintf('%s/cope%d', statsdir,copenum));
dm = read_vest(sprintf('%s/design.mat', featdir));

if(strcmp(t_or_f,'t'))
  c = read_vest(sprintf('%s/design.con', featdir));
else,
  fc = read_vest(sprintf('%s/design.fts', featdir));
end;

acs = read_avw(sprintf('%s/threshac1',statsdir));

ViewFMRI(xs, zs, 'glm_fit', 'glm_fit', copenum, t_or_f);

