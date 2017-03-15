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
	% be selected prior to passing it in. If not, this function will
	% try to guess which is the correct parcellation (but this will 
	% fail in many cases because OSL beamforming adds 2 valid montages
	% by default)

	% First, set the montage correctly
	if isa(D,'meeg')
		m = D.montage('getmontage');
		if length(m.channels) ~= self.n_voxels
			n_montages = D.montage('getnumber');
			n_chans = zeros(n_montages,1);
			for j = 1:n_montages
				m(j) = D.montage('getmontage',j);
				n_chans(j) = length(m(j).channels);
			end
			idx = find(n_chans == self.n_voxels);
			if isempty(idx)
				error('None of the montages have the same number of channels as the parcellation (%d)',self.n_voxels);
			elseif length(idx) == 1
				D = D.montage('switch',idx);
			else
				fprintf(2,'More than one montage has the same number of voxels as the parcellation. Set the montage before applying parcellation\n')
				for j = 1:length(idx)
					fprintf(2,'Montage %d - %s\n',idx(j),m(idx(j)).name);
				end
				error('Could not automatically select montage');
			end
		end
	end

	[D2,W] = ROInets.get_node_tcs(D,self.parcelflag,'PCA',[],false);

	if isa(D,'meeg')
		currentMontage = D.montage('getmontage');
		D2 = add_montage(D,W',['Parcellated ' currentMontage.name],self.labels);
	end
