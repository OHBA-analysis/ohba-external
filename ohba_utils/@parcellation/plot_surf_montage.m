function plot_surf_montage(p,data,varargin)
%function plot_surf_montage(p,data,varargin)
%
% Plot a simple montage of surface plots.
%
% Options
% inflation: {'midthickness','inflated','veryinflated'}
% montage: {'flat','radial'}
% clims: [low high]
% cmap: {Nx3 matrix of colors or string}
% add_colorbar: bool
%

arg = inputParser;

arg.addParameter('inflation','midthickness');
arg.addParameter('montage','single'); %{single flat radial}
arg.addParameter('interptype','trilinear'); %{trilinear,enclosing}
arg.addParameter('clims',[]);
arg.addParameter('cmap',[]);
arg.addParameter('add_colorbar',true)

arg.parse(varargin{:});
S = arg.Results; % Result of parsing arguments is essentially the settings struct

%% Convert data to Surface
niifile = p.savenii(data);
output_right    = [niifile '_right.func.gii'];
output_left     = [niifile '_left.func.gii'];
cl = onCleanup(@()  cellfun(@delete,{niifile,output_left,output_right})); % Enable deleting temp files even if debugging

lsurf = sprintf('ParcellationPilot.L.%s.32k_fs_LR.surf.gii',S.inflation);
rsurf = sprintf('ParcellationPilot.R.%s.32k_fs_LR.surf.gii',S.inflation);

surf_right = fullfile(osldir,'std_masks',lsurf);
surf_left = fullfile(osldir,'std_masks',rsurf);

display_surf_right = fullfile(osldir,'std_masks',rsurf);
display_surf_left = fullfile(osldir,'std_masks',lsurf);

% Map volume to surface
cmd = '/Applications/workbench/bin_macosx64/wb_command -volume-to-surface-mapping %s %s %s -%s';
runcmd(cmd,niifile,surf_right,output_right,S.interptype)
runcmd(cmd,niifile,surf_left,output_left,S.interptype)

sl = gifti(display_surf_left);
vl = gifti(output_left);
sr = gifti(display_surf_right);
vr = gifti(output_right);


%% Housekeeping for plot

% Set colourlims
if isempty(S.clims)
    clims = [min([min(vl.cdata) min(vr.cdata)]) max([max(vl.cdata) max(vr.cdata)])];
else
    clims = S.clims;
end

% make colormap
cm = S.cmap;
if ischar(cm) && strcmp(cm,'reds')
    r = ones(1,32);
    g = linspace(1,0,32);
    b = linspace(1,0,32);
    cm = [r;g;b]';
    cm = cat(1,[.6 .6 .6],cm);
elseif ischar(cm)
    cm = eval(cm,32);
elseif isempty(cm)
    cm = parula(64);
    cm = cat(1,[.6 .6 .6],cm);
end


%% Main figure

% We're making a montage
if strcmp(S.montage,'radial')
    hfig = figure('Position',[100 100 768 512]);

    ax(4) = axes('Position',[.05 .15 .33 .35]);
    ax(1) = axes('Position',[.05 .55 .33 .35]);
    ax(3) = axes('Position',[.375 .25 .25 .5]);
    ax(5) = axes('Position',[.62 .15 .33 .35]);
    ax(2) = axes('Position',[.62 .55 .33 .35]);
    cb_pos = [.4 .2 .2 .02];
    cb_orient = 'horizontal';
elseif strcmp(S.montage,'flat')

    hfig = figure('Position',[100 100 1024 256]);
    for ii = 1:5
        if ii==3
            ax(ii) = axes('Position',[.025+((ii-1)*.18)+.01 .1 .155 .8]);
        else
            ax(ii) = axes('Position',[.025+((ii-1)*.18) .3 .175 .5]);
        end
    end
    cb_orient = 'vertical';
    cb_pos = [.93 .3 .02 .5];
else
    error('montage type not recognised');
end

% lateral view
s(1) = patch(ax(1),'Faces',sl.faces,'vertices',sl.vertices,'CData',[]);
hold on
sg(1) = patch(ax(1),'Faces',sl.faces,'vertices',sl.vertices);

s(2) = patch(ax(2),'Faces',sr.faces,'vertices',sr.vertices,'CData',[]);
hold on
sg(2) = patch(ax(2),'Faces',sr.faces,'vertices',sr.vertices);

set(s(1),'FaceVertexCData',vl.cdata)
set(s(2),'FaceVertexCData',vr.cdata)

set(sg(1),'FaceVertexCData',0.4*ones(size(vl.cdata,1),3));
set(sg(2),'FaceVertexCData',0.4*ones(size(vr.cdata,1),3));
set(sg(1),'FaceVertexAlphaData',+~isfinite(vl.cdata),'FaceAlpha','interp','AlphaDataMapping','none');
set(sg(2),'FaceVertexAlphaData',+~isfinite(vr.cdata),'FaceAlpha','interp','AlphaDataMapping','none');

view(ax(1),[270 0])
view(ax(2),[-270 0])
clear s sg

% top view
s(1) = patch(ax(3),'Faces',sl.faces,'vertices',sl.vertices,'CData',[]);
hold on
sg(1) = patch(ax(3),'Faces',sl.faces,'vertices',sl.vertices);
s(2) = patch(ax(3),'Faces',sr.faces,'vertices',sr.vertices,'CData',[]);
sg(2) = patch(ax(3),'Faces',sl.faces,'vertices',sl.vertices);

set(s(1),'FaceVertexCData',vl.cdata)
set(s(2),'FaceVertexCData',vr.cdata)

set(sg(1),'FaceVertexCData',0.4*ones(size(vl.cdata,1),3));
set(sg(2),'FaceVertexCData',0.4*ones(size(vr.cdata,1),3));
set(sg(1),'FaceVertexAlphaData',+~isfinite(vl.cdata),'FaceAlpha','interp','AlphaDataMapping','none');
set(sg(2),'FaceVertexAlphaData',+~isfinite(vr.cdata),'FaceAlpha','interp','AlphaDataMapping','none');

clear s sg

% medial
s(1) = patch(ax(4),'Faces',sl.faces,'vertices',sl.vertices,'CData',[]);
hold on
sg(1) = patch(ax(4),'Faces',sl.faces,'vertices',sl.vertices);

s(2) = patch(ax(5),'Faces',sr.faces,'vertices',sr.vertices,'CData',[]);
hold on
sg(2) = patch(ax(5),'Faces',sr.faces,'vertices',sr.vertices);

set(s(1),'FaceVertexCData',vl.cdata)
set(s(2),'FaceVertexCData',vr.cdata)

set(sg(1),'FaceVertexCData',0.4*ones(size(vl.cdata,1),3));
set(sg(2),'FaceVertexCData',0.4*ones(size(vr.cdata,1),3));
set(sg(1),'FaceVertexAlphaData',+~isfinite(vl.cdata),'FaceAlpha','interp','AlphaDataMapping','none');
set(sg(2),'FaceVertexAlphaData',+~isfinite(vr.cdata),'FaceAlpha','interp','AlphaDataMapping','none');

view(ax(4),[90 0])
view(ax(5),[-90 0])
clear s sg


%% Set appearance

% Set shading
arrayfun(@(x) shading(x,'interp'),ax);

% Turn axis off
arrayfun(@(x) axis(x,'off'), ax);

% Set colourbar
if S.add_colorbar == true
    c = colorbar('orientation',cb_orient);
    c.Position = cb_pos;
    c.FontSize = 20;
end

%
for ii = 1:length(ax)
    axes(ax(ii))
    colormap(cm)
    axis('tight');
    if ~isempty(clims)
        caxis(clims);
    else
        mn = min([min(vl.cdata) min(vr.cdata)]);
        mx = max([max(vl.cdata) max(vr.cdata)]);
        if mn < 0
            m = max([ abs(mn) abs(mx) ]);
            caxis([-m m]);
        else
            caxis([0 mx])
        end
    end
    material( [0.1, 0.8, 0.2] );
    camlight('left')
    camlight('right')
    camlight('headlight')
end

end
