function self = remove_parcels(self,rm)
	% Remove specified parcels from the parcellation
	% 
	% Returns a parcellation with the specified parcels removed
	%
	% INPUTS
	% - Indices of parcels to remove, or logical vector with length equal to n_parcels
	%
	% EXAMPLES
	%
	% Suppose p is a parcellation object with 3 parcels
	%
	% - p2 = p.remove_parcels([1]) - Remove parcel 1
	% - p2 = p.remove_parcels([1 3]) - Remove parcels 1 and 3
	% - p2 = p.remove_parcels([1 0 1]) - Remove parcels 1 and 3

	if (islogical(rm) || all(ismember(rm,[0 1]))) && isvector(rm) && length(rm)==self.n_parcels
		retain = ~logical(rm);
	else
		retain = ~ismember(1:self.n_parcels,rm);
	end

	self.weight_mask = self.weight_mask(:,:,:,retain);
	self.labels = self.labels(retain);
