function plot_surface(p,data,surface_inflation,single_plot,interptype)
    % Render volume data onto a surface
    %
    % *REQUIRES WORKBENCH*
    %
    % INPUTS
    % - p - parcellation object
    % - data - data that can be saved to a nii file via p.savenii(data)
    % - surface_inflation - integer level of inflation for display surface (default=0, no inflation)
    % - single_plot - put the two hemispheres together (default=false, like Workbench)
    % - interptype - passed to workbench (default='trilinear')


    if nargin < 5 || isempty(interptype) 
        interptype = 'trilinear';
    end
    
    if nargin < 4 || isempty(single_plot) 
        single_plot = false;
    end

    if nargin < 3 || isempty(surface_inflation) 
        surface_inflation = 0;
    end

    if single_plot == true && surface_inflation ~= 0
        fprintf(2,'Warning, single plot with inflated surface does not currently plot correctly');
    end
    
    niifile = p.savenii(data);
    output_right    = [niifile '_right.func.gii'];
    output_left     = [niifile '_left.func.gii'];
    cl = onCleanup(@()  cellfun(@delete,{niifile,output_left,output_right})); % Enable deleting temp files even if debugging

    surf_right = fullfile(osldir,'std_masks','ParcellationPilot.R.midthickness.32k_fs_LR.surf.gii');
    surf_left = fullfile(osldir,'std_masks','ParcellationPilot.L.midthickness.32k_fs_LR.surf.gii');

    switch surface_inflation
        case 0
            display_surf_right = fullfile(osldir,'std_masks','ParcellationPilot.R.midthickness.32k_fs_LR.surf.gii');
            display_surf_left = fullfile(osldir,'std_masks','ParcellationPilot.L.midthickness.32k_fs_LR.surf.gii');
        case 1
            display_surf_right = fullfile(osldir,'std_masks','ParcellationPilot.R.inflated.32k_fs_LR.surf.gii');
            display_surf_left = fullfile(osldir,'std_masks','ParcellationPilot.L.inflated.32k_fs_LR.surf.gii');
        case 2
            display_surf_right = fullfile(osldir,'std_masks','ParcellationPilot.R.very_inflated.32k_fs_LR.surf.gii');
            display_surf_left = fullfile(osldir,'std_masks','ParcellationPilot.L.very_inflated.32k_fs_LR.surf.gii');
    end




    % Map volume to surface
    runcmd('wb_command -volume-to-surface-mapping %s %s %s -%s',niifile,surf_right,output_right,interptype)
    runcmd('wb_command -volume-to-surface-mapping %s %s %s -%s',niifile,surf_left,output_left,interptype)

    sl = gifti(display_surf_left);
    vl = gifti(output_left);
    sr = gifti(display_surf_right);
    vr = gifti(output_right);
    hfig = figure;

    if single_plot
        ax = gca;
        s(1) = patch(ax,'Faces',sl.faces,'vertices',sl.vertices,'CData',[]);
        hold on
        sg(1) = patch(ax,'Faces',sl.faces,'vertices',sl.vertices);
        s(2) = patch(ax,'Faces',sr.faces,'vertices',sr.vertices,'CData',[]);
        sg(2) = patch(ax,'Faces',sl.faces,'vertices',sl.vertices);


    else
        set(hfig,'Position',[1 1 2 1].*get(hfig,'Position'));
        ax(1) = subplot(1,2,1);
        s(1) = patch(ax(1),'Faces',sl.faces,'vertices',sl.vertices,'CData',[]);
        hold on
        sg(1) = patch(ax(1),'Faces',sl.faces,'vertices',sl.vertices);

        ax(2) = subplot(1,2,2);
        s(2) = patch(ax(2),'Faces',sr.faces,'vertices',sr.vertices,'CData',[]);
        hold on
        sg(2) = patch(ax(2),'Faces',sr.faces,'vertices',sr.vertices);

        lrotate = addlistener(ax(1),'View','PostSet',@(a,b,c) set(ax(2),'View',[-1 1].*get(ax(1),'View')));
        rrotate = addlistener(ax(2),'View','PostSet',@(a,b,c) set(ax(1),'View',[-1 1].*get(ax(2),'View')));

    end

    set(s(1),'FaceVertexCData',vl.cdata)
    set(s(2),'FaceVertexCData',vr.cdata)

    set(sg(1),'FaceVertexCData',0.4*ones(size(vl.cdata,1),3));
    set(sg(2),'FaceVertexCData',0.4*ones(size(vr.cdata,1),3));
    set(sg(1),'FaceVertexAlphaData',+~isfinite(vl.cdata),'FaceAlpha','interp','AlphaDataMapping','none');
    set(sg(2),'FaceVertexAlphaData',+~isfinite(vr.cdata),'FaceAlpha','interp','AlphaDataMapping','none');

    axis(ax,'equal');
    axis(ax,'vis3d');
    set(ax(1),'View', [-90 0]);
    set(ax,'CLim',[min([vl.cdata;vr.cdata]) max([vl.cdata;vr.cdata])]);

    arrayfun(@(x) shading(x,'interp'),ax);
    arrayfun(@(x) colorbar(x,'Location','SouthOutside'),ax);
    axis(ax,'off');
    rotate3d(hfig,'on');

