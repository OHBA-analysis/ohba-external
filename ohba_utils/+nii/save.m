function fname = save(vol,res,xform,fname)
	% Save a nii file together with a given xform matrix
	%
	% INPUTS
	% vol - volume matrix to save to nii file
	% res - Spatial resolution
	% fname - File name of nii file to save
	% xform - Optional 4x4 matrix. If left empty, then an identity matrix will be assumed
	% The NIFTI toolbox will set sformcode=1 and nii.load() will display a warning
	% if this is the case, to indicate the information may be missing
	%
	% Could use osl_load_nii to get res and xform from a standard mask
	%
	% Romesh Abeysuriya 2017
	
	% Resolution can be specified in 3 ways
	% - Single number = same in all dimensions, with time resolution of 1
	% - 3 numbers, different in all dimensions, time resolution of 1
	% - 4 numbers, complete resolution specification
	
	% Possible output filenames
	% - 'fname'
	% - 'fname.nii'
	% - 'fname.nii.gz'
	if isempty(strfind(fname,'.nii'))
		fname = [fname '.nii.gz'];
	elseif isempty(strfind(fname,'.gz'))
		fname = [fname '.gz'];
	end

	switch length(res)
		case 1
			r = [res res res];
		case 3
			r = [res];
		case 4
			r = res(1:3);
		otherwise
			error('Unknown resolution - should be 1, 3, or 4 elements long');
    end

    nii = make_nii(vol,r);

    if length(res) > 3
    	nii.hdr.dime.pixdim(1+(1:length(res))) = res;
    end

    if ~isempty(xform)
    	assert(all(size(xform)==[4 4]),'xform must be a 4x4 matrix')
    	nii.hdr.hist.qform_code = 0;
    	nii.hdr.hist.sform_code = 4;
    	nii.hdr.hist.srow_x = xform(1,:);
    	nii.hdr.hist.srow_y = xform(2,:);
    	nii.hdr.hist.srow_z = xform(3,:);
    else
    	fprintf(2,'Warning - saving a NIFTI file without xform matrix is not generally recommended\n')
    end

    save_nii(nii,fname);
