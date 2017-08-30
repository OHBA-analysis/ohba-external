function [spatial_res,mask_fname,mask] = guess_template(m)
	% Guess the spatial mask and resolution that goes with some input
	% 
	% POSSIBLE INPUTS
	% - A spatial resolution e.g. m = 8
	% - A vector of voxels (voxels x 1)
	% - A matrix of parcels (voxels x parcels)
	% - A volume (XYZ)
	% - A volume-based parcellation (XYZ x parcels)
	% - An MEEG object with a source space montage
	% 
	% Return values
	% spatial_res - The guessed spatial resolution
	% mask_fname - The filename for the standard mask
	% mask - The result of reading the mask file using nii.load()
	%
	% Romesh Abeysuriya 2017
	
   	% Sanitize the input
	if isa(m,'meeg')
		m = m(:,1,1);
	end 

	% Given a 4D matrix, it's probably XYZ x parcels, so just keep the first volume
	if ndims(m) == 4
		m = squeeze(m(:,:,:,1));
    end

    if isvector(m)
        m = m(:);
    end
    
	% If its a 2D matrix, its probably voxels x parcels, so just keep the first column
	if ndims(m) == 2
		m = m(:,1);
	end

	% Commands below generate the sizes listed in this file
	% OSLDIR = getenv('OSLDIR');
	% mask_dim = [];
	% mask_vox = [];
	% for j = 1:length(mask_res)
	% 	a=nii.load(sprintf([OSLDIR '/std_masks/MNI152_T1_%dmm_brain.nii.gz'],mask_res(j)));
	% 	mask_dim(j,:) = size(a);
	% 	mask_vox(j) = sum(a(:)~=0);
	% end

	mask_res = [1:15];

	mask_dim = [...
	   182   218   182;...
	    91   109    91;...
	    61    73    61;...
	    46    55    46;...
	    36    44    36;...
	    30    36    30;...
	    26    31    26;...
	    23    27    23;...
	    20    24    20;...
	    18    22    18;...
	    17    20    17;...
	    15    18    15;...
	    14    17    14;...
	    13    16    13;...
	    12    15    12];

	mask_vox = [1827095,228453,67693,28549,14641,8471,5339,3559,2518,1821,1379,1065,833,676,544];

	ft_mask_res = [4 5 6 8 10];

	ft_mask_dim = [...
		38    48    41;...
		32    39    34;...
		26    33    28;...
		20    25    22;...
		18    21    18];

	ft_mask_vox = [37163,20173,12337,5798,3294];

	[spatial_res,mask_fname] = match(m,mask_res,mask_vox,mask_dim,'MNI152_T1_%dmm_brain.nii.gz');
	
	if isempty(spatial_res)
		[spatial_res,mask_fname] = match(m,ft_mask_res,ft_mask_vox,ft_mask_dim,'ft_%dmm_brain.nii.gz');
	end

	if isempty(spatial_res)
		error('osl:parcellation:no_matching_mask','No masks have the correct spatial resolution');
	end

	mask_fname = fullfile(osldir,'std_masks',mask_fname);
	
	if nargout > 2
		mask = nii.load(mask_fname);
	end
end


function [output_res,mask_fname] = match(m,res,vox,dim,fname)
	output_res = [];
	mask_fname = [];

	if numel(m) == 1
		idx = find(res == m);
	elseif isvector(m) % If column vector given
		idx = find(vox == length(m));
	else
		idx = find(all(bsxfun(@eq,dim,size(m)),2));
	end

	if isempty(idx)
		return
	end

	output_res = res(idx);
	mask_fname = sprintf(fname,output_res);
end

