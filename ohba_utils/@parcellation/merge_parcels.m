function self = merge_parcels(self,merge_list)
	% Returns a parcellation with specified parcels merged
	%
	% Parcels are merged by addition of the weight mask
	% This may have unexpected effects for a weighted parcellation
	%
	% Merged parcels appear at the end of the parcellation
	% The affected parcels will be removed
	% Labels will be automatically updated
	%
	% INPUTS
	% - merge list - cell array containing indices of parcels to be merged
	%
	% EXAMPLE USAGE
	% Suppose we have a parcellation with 10 parcels
	%
	% 	p = p.merge_parcels({[1 2],[5 6 7]})
	%
	% will delete parcels 1,2,5,6,7, and add two parcels at the end 
	%
	% 	p = p.merge_parcels({[1 2],[1 3]})
	%
	% will delete parcels 1,2,3, and add two parcels at the end
	% 
	% If you want to add new parcels without deleting the old ones, it is suggested
	% to just add them manually e.g.
	% 
	% p.weight_mask(:,:,:,end+1) = sum(p.weight_mask(:,:,:,[1 2]),4);
	% p.labels{end+1} = 'my new parcel';

	for j = 1:length(merge_list)
		merge_list{j} = merge_list{j}(:);
	end

	parcels_affected = unique(cell2mat(merge_list(:)));

	retain = ~ismember(1:self.n_parcels,parcels_affected);

	new_weight_mask = self.weight_mask(:,:,:,retain);
	new_labels = self.labels(retain);

	for j = 1:length(merge_list)
		new_weight_mask(:,:,:,sum(retain)+j) = sum(self.weight_mask(:,:,:,merge_list{j}),4);
		new_labels{sum(retain)+j} = sprintf('%s+',self.labels{merge_list{j}});
		new_labels{sum(retain)+j} = new_labels{end}(1:end-1);
	end

	self.weight_mask = new_weight_mask;
	self.labels = new_labels;