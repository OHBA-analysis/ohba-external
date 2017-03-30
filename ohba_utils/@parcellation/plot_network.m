function [p,s] = plot_network(self,cmat,threshold,node_vals,labels)
	% Plot connection matrices as network with edges (quick version)

	% INPUTS
	% - cmat : n_parcels x n_parcels matrix
	% - threshold : Automatically hide (using alpha) connections below threshold (can modify alpha limits afterwards)
	% - node_vals : Optional scalar or n_parcels x 1 vector of sizes for nodes (Default = NaN, no nodes plotted)
	% - labels : set to 'true' to display labels drawn from the parcellation. Set to a cell array to specify names. Leave empty or false otherwise
	%
	% OUTPUTS
	% - p : Handle to patch containing lines, with colour set to cmat vals, and alpha set to abs(cmat)
	% - s : Handle to scatter object representing nodes
	% 
	% The line colour values are the original cmat values, and the colour is scaled to colormap
	% To recolor the plot, simply change the axis clim property.
	% Similarly, the line transparency is scaled according to the percentile of the data
	% To change which lines are visible, adjust the axis alim property
	%
	% Example
	% [h_patch,h_scatter] = p.plot_network(cmat)
	% set(gcf,'CLim',[-1 1]) % Change line colour after rendering
	% set(gca,'ALim',[0 1]) % Make all lines visible
	% set(gca,'ALim',[0.95 1]) % Start fading in connections above the 95th percentile
	% set(gca,'ALim',[0.95 0.95+eps]) % Hard threshold visibility at the 95th percentile
	% set(h_patch,'LineWidth',1) % Change the line width uniformly

	if nargin < 5 || isempty(labels) 
		labels = [];
	elseif numel(labels) == 1 && labels == true
		labels = self.labels
	elseif iscell(labels)
		assert(length(labels) == self.n_parcels,'Number of labels must match number of parcels in parcellation');
	else
		labels = []; % If labels is false or otherwise unrecognized
	end
	
	if nargin < 4 || isempty(node_vals) 
		node_vals = NaN;
	end

	if nargin < 3 || isempty(threshold) 
		threshold = 0.95;
	end
	
	assert(size(cmat,1) == size(cmat,2),'Input matrix must be square');
	assert(size(cmat,1) == self.n_parcels,sprintf('Correlation matrix has %d ROIs, but parcellation has %d parcels',size(cmat,1),self.n_parcels));
	
	% Get just the upper triangle indices and corresponding from/to ROIs
	ind = find(triu(ones(size(cmat)),1));
	[from,to] = ind2sub(size(cmat),ind);

	% Render the brain surface
	f=figure('Color','w');
	mesh = gifti(fullfile(osldir,'spm12','canonical','cortex_20484.surf.gii'));
	trisurf(mesh.faces,mesh.vertices(:,1),mesh.vertices(:,2),mesh.vertices(:,3),'facecolor',0.5*[1 1 1],'edgecolor','none','FaceAlpha',0.1,'AlphaDataMapping','direct')
	axis equal
	axis vis3d
	axis tight

	axis off
	hold on
	cmap = colormap(bluewhitered(256));
	colorbar

	set(gca,'CLim',[-1 1]*max(abs(cmat(ind)))); % Colour axis limit is symmetric and based on maximum off-diagonal of the data

	roi_centers = self.roi_centers;
	p = patch('Vertices',roi_centers([from;to],:),'Faces',[1:length(from);length(from)+1:2*length(from)].','FaceColor','none','LineWidth',3,'CDataMapping','scaled','AlphaDataMapping','scaled');
	set(p,'FaceVertexCData',cmat([ind;ind]))

	s = scatter3(roi_centers(:,1),roi_centers(:,2),roi_centers(:,3),node_vals,'o','filled','MarkerFaceColor',cmap(1,:));

	% Compute the percentile of the absolute value
	amat = arrayfun(@(x) (sum(abs(cmat(ind)) < x) + 0.5)/length(ind),abs(cmat(ind)));
	set(p,'FaceVertexAlphaData',[amat;amat])
	set(p,'EdgeAlpha','flat','EdgeColor','flat')

	set(gca,'ALim',[threshold threshold+1e-5]);

	if ~verLessThan('matlab','8.4')
		set(gca,'SortMethod','child');
	end

	if ~isempty(labels)
		text(1.1*roi_centers(:,1),1.1*roi_centers(:,2),1.1*roi_centers(:,3), labels, 'FontSize',12,'HorizontalAlignment','center')
	end




