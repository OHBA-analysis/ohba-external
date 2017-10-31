function hfig = plot_surface(p,data,surface_inflation,single_plot,interptype)
    % Render volume data onto a surface
    %
    % *REQUIRES WORKBENCH*
    %
    % INPUTS
    % - p - parcellation object
    % - data - data that can be saved to a nii file via p.savenii(data)
    % - surface_inflation - integer level of inflation for display surface
    %   (default=0, no inflation)
    % - single_plot - put the two hemispheres together (default=false, like
    %   Workbench)
    % - interptype - passed to workbench (default='trilinear')
    %
    % If the data has more than one volume, the output plot will also have
    % more than one volume. The figure has a property 'current_vol' that lets
    % you set the which one is displayed e.g.
    %
    % h = p.plot_surface(data) h.current_vol = 2; % Display second volume
    %
    % The buttons on the top of the figure let you manually cycle through
    % volumes, or display them in sequence


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
    hfig = figure();

    if single_plot
        ax = gca;
        s(1) = patch(ax,'Faces',sl.faces,'vertices',sl.vertices,'CData',[]);
        hold on
        sg(1) = patch(ax,'Faces',sl.faces,'vertices',sl.vertices);
        s(2) = patch(ax,'Faces',sr.faces,'vertices',sr.vertices,'CData',[]);
        sg(2) = patch(ax,'Faces',sl.faces,'vertices',sl.vertices);
    else
        overrun = 0.05;
        ax(1) = axes('OuterPosition',[0-overrun 0.0 0.5+overrun*2 1]); 
        s(1) = patch(ax(1),'Faces',sl.faces,'vertices',sl.vertices,'CData',[]);
        hold on
        sg(1) = patch(ax(1),'Faces',sl.faces,'vertices',sl.vertices);
        t(1) = title(ax(1),' ')

        ax(2) = axes('OuterPosition',[0.5-overrun 0.0 0.5+overrun*2 1]); 
        s(2) = patch(ax(2),'Faces',sr.faces,'vertices',sr.vertices,'CData',[]);
        hold on
        sg(2) = patch(ax(2),'Faces',sr.faces,'vertices',sr.vertices);

        lrotate = addlistener(ax(1),'View','PostSet',@(a,b,c) set(ax(2),'View',[-1 1].*get(ax(1),'View')));
        rrotate = addlistener(ax(2),'View','PostSet',@(a,b,c) set(ax(1),'View',[-1 1].*get(ax(2),'View')));

        xmax = max(abs([sl.vertices(:,1);sr.vertices(:,1)]));
        set(ax(1),'XLim',[-xmax 5],'XLimMode','manual') 
        set(ax(2),'XLim',[-5 xmax],'XLimMode','manual') 
        set(ax,'YLim',[min([sl.vertices(:,2);sr.vertices(:,2)]) max([sl.vertices(:,2);sr.vertices(:,2)]) ]) 
        set(ax,'ZLim',[min([sl.vertices(:,3);sr.vertices(:,3)]) max([sl.vertices(:,3);sr.vertices(:,3)]) ]) 
    end

    addprop(hfig,'left_cdata');
    addprop(hfig,'right_cdata');
    hfig.left_cdata = vl.cdata;
    hfig.right_cdata = vr.cdata;
    t = uicontrol(hfig,'style','text','position',[20    20    80    20]);

    set(ax,'DataAspectRatio',[1 1 1])


    %axis(ax,'equal');
    axis(ax,'vis3d');
    set(ax(1),'View', [-90 0]);
    set(ax,'CLim',[min([vl.cdata(:);vr.cdata(:)]) max([vl.cdata(:);vr.cdata(:)])]);

    arrayfun(@(x) shading(x,'interp'),ax);
    arrayfun(@(x) colorbar(x,'Location','SouthOutside'),ax);
    axis(ax,'off');
    rotate3d(hfig,'on');

    tb = uitoolbar(hfig);
    cdata = button_cdata();
    b(1) = uipushtool(tb,'CData',cdata.prev,'ClickedCallback',@(a,b,c) prev(hfig));
    b(2) = uipushtool(tb,'CData',cdata.next,'ClickedCallback',@(a,b,c) next(hfig));
    b(3) = uipushtool(tb,'CData',cdata.play,'ClickedCallback',@(a,b,c) play(hfig));
    b(4) = uipushtool(tb,'CData',cdata.stop,'ClickedCallback',@(a,b,c) stop(hfig));

    addprop(hfig,'playing');
    hfig.playing = 0;
    p = addprop(hfig,'current_vol');
    p.SetObservable = true;
    hfig.UserData = addlistener(hfig,'current_vol','PostSet',@(a,b,c) sync(hfig,s,sg,t));
    hfig.current_vol = 1;

function next(hfig)
    hfig.current_vol = 1+mod(hfig.current_vol,size(hfig.left_cdata,2));

function prev(hfig)
    hfig.current_vol = 1-mod(hfig.current_vol,size(hfig.left_cdata,2));

function play(hfig)
    if size(hfig.left_cdata,2) > 1
        hfig.playing = 1;
        while get(hfig,'playing')
            next(hfig);
        end
    end

function stop(hfig)
    hfig.playing = 0;

function sync(hfig,s,sg,t)
    set(s(1),'FaceVertexCData',hfig.left_cdata(:,hfig.current_vol));
    set(s(2),'FaceVertexCData',hfig.right_cdata(:,hfig.current_vol));
    set(sg(1),'FaceVertexCData',0.4*ones(size(hfig.left_cdata,1),3));
    set(sg(2),'FaceVertexCData',0.4*ones(size(hfig.right_cdata,1),3));
    set(sg(1),'FaceVertexAlphaData',+~isfinite(hfig.left_cdata(:,hfig.current_vol)),'FaceAlpha','interp','AlphaDataMapping','none');
    set(sg(2),'FaceVertexAlphaData',+~isfinite(hfig.right_cdata(:,hfig.current_vol)),'FaceAlpha','interp','AlphaDataMapping','none');
    set(t,'String',sprintf('%d of %d',hfig.current_vol,size(hfig.left_cdata,2)));
    drawnow

function cdata = button_cdata()

    levels = [0.94 0.90 0.5 0.06];

    play = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 3 2 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 4 4 3 2 1 1 1 1 1 1 1 1 1;...
             1 1 1 4 4 4 4 3 2 1 1 1 1 1 1 1;...
             1 1 1 4 4 4 4 4 4 3 2 1 1 1 1 1;...
             1 1 1 4 4 4 4 4 4 4 4 3 2 1 1 1;...
             1 1 1 4 4 4 4 4 4 4 4 4 4 3 1 1;...
             1 1 1 4 4 4 4 4 4 4 4 4 4 3 1 1;...
             1 1 1 4 4 4 4 4 4 4 4 3 2 1 1 1;...
             1 1 1 4 4 4 4 4 4 3 2 1 1 1 1 1;...
             1 1 1 4 4 4 4 3 2 1 1 1 1 1 1 1;...
             1 1 1 4 4 3 2 1 1 1 1 1 1 1 1 1;...
             1 1 1 3 2 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

    stop = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 4 4 4 4 4 4 4 4 4 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];


    next = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 4 4 2 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 2 4 4 2 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 2 4 4 2 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 2 4 4 2 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 2 4 4 2 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 2 4 4 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 2 4 4 1 1 1 1 1;...
             1 1 1 1 1 1 1 2 4 4 2 1 1 1 1 1;...
             1 1 1 1 1 1 2 4 4 2 1 1 1 1 1 1;...
             1 1 1 1 1 2 4 4 2 1 1 1 1 1 1 1;...
             1 1 1 1 1 4 4 2 1 1 1 1 1 1 1 1;...
             1 1 1 1 4 4 2 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

    prev = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 2 4 4 1 1 1 1;...
             1 1 1 1 1 1 1 1 2 4 4 2 1 1 1 1;...
             1 1 1 1 1 1 1 2 4 4 2 1 1 1 1 1;...
             1 1 1 1 1 1 2 4 4 2 1 1 1 1 1 1;...
             1 1 1 1 1 2 4 4 2 1 1 1 1 1 1 1;...
             1 1 1 1 2 4 4 2 1 1 1 1 1 1 1 1;...
             1 1 1 1 2 4 4 2 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 2 4 4 2 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 2 4 4 2 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 2 4 4 2 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 2 4 4 2 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 2 4 4 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
             1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

    cdata.play = repmat(levels(play),1,1,3);
    cdata.stop = repmat(levels(stop),1,1,3);
    cdata.next = repmat(levels(next),1,1,3);
    cdata.prev = repmat(levels(prev),1,1,3);

