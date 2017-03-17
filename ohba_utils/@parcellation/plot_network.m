function [h_lines,h_nodes] = plot_network(self,cmat,threshold,node_vals)
	% Plot connection matrices as network with edges (quick version)

	% INPUTS
	% - cmat : n_parcels x n_parcels matrix
	% - threshold : Automatically hide (using alpha) connections below threshold (can modify alpha limits afterwards)
	% - node_vals : Optional n_parcels x 1 vector of sizes for nodes (Default = 30)

	if nargin < 4 || isempty(node_vals) 
		node_vals = 30;
	end

	if nargin < 3 || isempty(threshold) 
		threshold = 0.95;
	end
	

	assert(size(cmat,1) == size(cmat,2),'Input matrix must be square');
	assert(size(cmat,1) == self.n_parcels,sprintf('Correlation matrix has %d ROIs, but parcellation has %d parcels',size(cmat,1),self.n_parcels));
	
	% Render the brain surface
	f=figure('Color','w');
	mesh = gifti(fullfile(osldir,'spm12','canonical','cortex_5124.surf.gii'));
	trisurf(mesh.faces,mesh.vertices(:,1),mesh.vertices(:,2),mesh.vertices(:,3),'facecolor',0.5*[1 1 1],'edgecolor','none','FaceAlpha',0.1,'AlphaDataMapping','direct')
	

	axis equal
	axis vis3d
	axis tight

	axis off
	hold on
	cmap = colormap(bluewhitered(256));
	colorbar
	set(gca,'CLim',[-1 1]*max(abs(cmat(:)))); % Colour axis limit is symmetric and based on maximum range of the data

	roi_centers = self.roi_centers;
	h_nodes = scatter3(roi_centers(:,1),roi_centers(:,2),roi_centers(:,3),node_vals,'o','filled','MarkerFaceColor',cmap(1,:));

	% Find the indices for edges to plot
	ind = find(triu(ones(size(cmat)),1));
	[from,to] = ind2sub(size(cmat),ind);


	% from = from([1 10])
	% to = to([1 10])
	roi_centers(end+1,:) = [NaN NaN NaN]; % Add a separator
	c = roi_centers(reshape([from to size(roi_centers,1)*ones(size(from))]',[],1),:)  % Interleave
	p = patch('XData',c(:,1),'YData',c(:,2),'ZData',c(:,3),'FaceColor','none')
	
	keyboard
	return


	p = patch('XData',c(:,1),'YData',c(:,2),'ZData',c(:,3),'EdgeAlpha','flat','EdgeColor','flat','FaceAlpha',0,'LineWidth',3,'CDataMapping','scaled','AlphaDataMapping','scaled') 
	set(p,'FaceVertexCData',cmat(reshape([ind ind]',[],1)))
	set(p,'FaceVertexAlphaData',abs(cmat(reshape([ind ind]',[],1))))

	set(gca,'ALim',[prctile(abs(cmat(:)),100*threshold) max(abs(cmat(:)))]);

	if ~verLessThan('matlab','8.4')
		set(gca,'SortMethod','child');
	end




