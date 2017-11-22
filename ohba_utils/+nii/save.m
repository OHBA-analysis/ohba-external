function fname = save(vol,res,xform,fname,xform_codes)
    % Save a nii file together with a given xform matrix
	%
    % INPUTS
    % - vol : volume matrix to save to nii file
    % - res : Spatial resolution
    % - xform : Optional 4x4 matrix. If left empty, then an identity matrix
    %   will be assumed. The NIFTI toolbox will set sformcode=1 and nii.load()
    %   will display a warning if this is the case, to indicate the
    %   information may be missing
    % - fname : File name of nii file to save
    % - xform_codes : Two element vector with [sform_code qform_code]. Default
    %   is [4 0] which corresponds to standard MNI space. The default values
    %   should generally be used unless you are working with scanner-
    %   anatomical images. At the moment, this file only sets the sform matrix
    %   which means that the qform code MUST be zero, as there is no way to ensure 
    %   that qform remains valid when using this function.
	%
	% Resolution can be specified as a scalar, which is used for all 3 spatial
	% dimensions, or as a vector that gets inserted into the NIFTI header pixdim
	% e.g. [8 8 8] or [8 8 8 1] or longer
	%
	% Output will automatically have '.nii.gz' added to the extension if not provided
	% and this extension will be included in the returned fname. That is, the return
	% value of this function reflects what is actually written to disk
	%
	% Romesh Abeysuriya 2017

    if nargin < 5 || isempty(xform_codes) 
        xform_codes = [4 0];
    end

    assert(xform_codes(2) == 0,'Saving via nii.save() does not ensure qform is set correctly, so qform_code must equal 0')
    
    fname = strtrim(fname);
    [pathstr,fname,ext] = fileparts(fname);
    if isempty(ext) || strcmp(ext,'.nii')
        ext = '.nii.gz';
    end
    fname = fullfile(pathstr,[fname,ext]);

    if length(res) == 1
    	res = [res res res];
    end

    nii = make_nii(vol,res(1:3)); % Call make_nii with the first part of the resolution
	nii.hdr.dime.pixdim(1+(1:length(res))) = res;

    if ~isempty(xform)
    	assert(all(size(xform)==[4 4]),'xform must be a 4x4 matrix')
    	nii.hdr.hist.sform_code = xform_codes(1);
        nii.hdr.hist.qform_code = xform_codes(2);
    	nii.hdr.hist.srow_x = xform(1,:);
    	nii.hdr.hist.srow_y = xform(2,:);
    	nii.hdr.hist.srow_z = xform(3,:);
    else
    	fprintf(2,'Warning - saving a NIFTI file without xform matrix is not generally recommended\n')
    	dbstack
    end

    save_nii(nii,fname);
