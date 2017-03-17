function D2 = apply_parcellation(self,D)
	% Apply parcellation to voxel data
	%
	% Take in a matrix or SPM MEEG object supported by get_node_tcs
	% Return a matrix if input was a matrix
	% Return an MEEG with online montage if input was an MEEG object
	% 
	% NOTE - Unlike get_node_tcs, parcellation is applied IN MEMORY
	% To save changes to disk, use
	%
	%     D = p.apply_parcellation(D)
	%	  D.save()
	%
	% If the input is an MEEG object, then the correct montage should
	% be selected prior to passing it in. 
    
	% First, set the montage correctly
	if isa(D,'meeg')
        assert(D.nchannels == self.n_voxels,sprintf('Parcellation has %d voxels but MEEG object has %d channels. Is the correct montage active?',D.nchannels,self.n_voxels));
    end

    % Display a warning if the parcellation is being binarized
    if self.is_weighted || self.is_overlapping
		fprintf(2,'Warning - parcellation is being binarized\n')
    end
    
	[D2,W] = ROInets.get_node_tcs(D,self.parcelflag(true),'PCA',[],false);

	if isa(D,'meeg')
		currentMontage = D.montage('getmontage');
		D2 = add_montage(D,W',['Parcellated ' currentMontage.name],self.labels);
	end
