function self = remove_parcels(self,indices_to_remove)
	% Remove specified parcels from the parcellation
	% 
	% Returns a parcellation with the specified parcels removed
	%
	% INPUTS
	% - Indices of parcels to remove

	retain = ~ismember(1:self.n_parcels,indices_to_remove);
	self.weight_mask = self.weight_mask(:,:,:,retain);
	self.labels = self.labels(retain);
