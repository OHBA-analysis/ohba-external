function show_parcellation(p)
	% Interactive tool to view ROIs
	
	% Plot the cortical surface
	f=figure;
	mesh = gifti(fullfile(osldir,'spm12','canonical','cortex_5124.surf.gii'));
	trisurf(mesh.faces,mesh.vertices(:,1),mesh.vertices(:,2),mesh.vertices(:,3),'facecolor',0.5*[1 1 1],'edgecolor','none','FaceAlpha',0.1)
	axis equal
	axis tight
	axis vis3d
	hold on

	% Add numbers to ROI names in dropdown list
	nstr = arrayfun(@(j) sprintf('%d - %s',j,p.labels{j}),1:p.n_parcels,'UniformOutput',false);
	a = uicontrol(f,'Style','popupmenu','String',nstr,'Value',1,'Units','characters');
	a.Position(3) = 50;

	h_roi = scatter3(NaN,NaN,NaN,30,'r'); % Handle to scatter plot to show ROI coordinates

	a.Callback = @(a,b,c) draw_roi(p,a.Value,h_roi);
	a.Callback(a); % Show the first ROI immediately

end

function draw_roi(p,idx,h_roi)
    h_roi.XData = p.roi_coordinates{idx}(:,1);
    h_roi.YData = p.roi_coordinates{idx}(:,2);
    h_roi.ZData = p.roi_coordinates{idx}(:,3);
end