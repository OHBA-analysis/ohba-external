function show_parcellation(p)
	% Interactive tool to view ROIs
	
	% Plot the cortical surface
	f=figure;
	mesh = gifti(fullfile(osldir,'spm12','canonical','cortex_5124.surf.gii'));
	trisurf(mesh.faces,mesh.vertices(:,1),mesh.vertices(:,2),mesh.vertices(:,3),'facecolor',0.5*[1 1 1],'edgecolor','none','FaceAlpha',0.1)
	axis equal
	axis tight
	axis vis3d
	set(gca,'XLim',[min(p.template_coordinates(:,1)) max(p.template_coordinates(:,1))],'YLim',[min(p.template_coordinates(:,2)) max(p.template_coordinates(:,2))],'ZLim',[min(p.template_coordinates(:,3)) max(p.template_coordinates(:,3))]);
	hold on

	% Add numbers to ROI names in dropdown list
	nstr = arrayfun(@(j) sprintf('%d - %s',j,p.labels{j}),1:p.n_parcels,'UniformOutput',false);
	a = uicontrol(f,'Style','popupmenu','String',nstr,'Value',1,'Units','characters');
	pos = get(a,'Position');
    set(a,'Position',[pos(1:2) 50 pos(4)]);

	h_roi = scatter3(NaN,NaN,NaN,30,'r'); % Handle to scatter plot to show ROI coordinates
        
	set(a,'Callback',@(a,b,c) draw_roi(p,a,h_roi));
	draw_roi(p,a,h_roi); % Show the first ROI immediately

end

function draw_roi(p,a,h_roi)
    idx = get(a,'Value');
    set(h_roi,'XData',p.roi_coordinates{idx}(:,1),'YData',p.roi_coordinates{idx}(:,2),'ZData',p.roi_coordinates{idx}(:,3));
end