function self = split_parcels(self,parcels_to_split,n_splits)
	% Returns a parcellation with specified parcels split
	% using k-means clustering.
	%
	% INPUTS
	% - parcels_to_split - which parcels should be subdivided, leave empty to divide all
	% - n_splits - 1 element, or one element for each in parcels_to_split. Number of clusters in k-means
	%

	% Currently only designed to work with unweighted parcels
	assert(self.is_weighted==0,'Only designed for unweighted parcellations')

	if nargin < 2 || isempty(parcels_to_split) 
		parcels_to_split = 1:self.n_parcels;
	end

	if nargin < 3 || isempty(n_splits) 
		n_splits = 2;
	end

	assert(isvector(parcels_to_split),'parcels_to_split must be a vector');
	assert(isvector(n_splits),'n_splits must be a vector');
	assert(length(unique(parcels_to_split))==length(parcels_to_split),'A parcel can only appear once in parcels_to_split')
	
	if length(n_splits) == 1
		n_splits = n_splits.*ones(size(parcels_to_split));
	else
		assert(length(n_splits)==length(parcels_to_split),'Number of splits must be scalar, or match the number of parcels being split');
	end
	
	% Now come up with a new weight matrix
	n_new_parcels = sum(n_splits-1); % Number of new parcels being added
	m = self.to_matrix;
	m2 = zeros(self.n_voxels,self.n_parcels + n_new_parcels);
	labels = cell(size(m2,2),1);

	ptr = 1;

	% Do it reproducibly
	s = RandStream('mt19937ar','Seed',0);
	options = statset('Streams',s);

	% For each parcel being split
	for j = 1:self.n_parcels

		split_idx = find(parcels_to_split == j);
		if isempty(split_idx)
			m2(:,ptr) = m(:,j);
			labels{ptr} = self.labels{j};
			ptr = ptr + 1;
		else % Split the parcel
			vox_idx = find(m(:,j));
			c = self.template_coordinates(vox_idx,:);
			idx = kmeans(c,n_splits(split_idx),'Replicates',10,'Options',options); % Split the parcel
			for k = 1:n_splits(split_idx)
				m2(vox_idx(idx==k),ptr) = m(vox_idx(idx==k),j);
				labels{ptr} = sprintf('%s - split %d',self.labels{j},k);
				ptr = ptr + 1;
			end
		end

	end

	self.weight_mask = self.to_vol(m2);
	self.labels = labels;
