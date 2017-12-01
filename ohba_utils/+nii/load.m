function [vol,res,xform,xform_codes,toffset,tunits] = load(fname)
	% Load a nii volume together with the spatial resolution and xform matrix
	%
	% INPUTS
	% - fname : File name of a NIFTI file on disk. If the file does not exist,
	%   '.nii' and '.nii.gz' will be tried. If either one exists, it will be
	%   used. If both exist, an error will be thrown because it is unclear
	%   which one to use.
	%
	% OUTPUTS
	% - vol : Volume data (same as read_avw)
	% - res : 4 elements of the NIFTI header pixdim field (X,Y,Z,T)
	% - xform : 4x4 transform matrix. If the NIFTI file's sform code is >0 OR if both the sform and qform codes are zero, then sform will be used when returning the xform matrix, otherwise the xform matrix will be computed from the qform quarternion representation
	% - xform_codes : The sform code and qform code in the image (see also nii.save())
	%
	% Romesh Abeysuriya 2017

	assert(ischar(fname),'Input file name must be a string')
    fname = strtrim(fname);

    [pathname,basename,ext] = fileparts(fname);
    
    if isempty(ext)

    	ext_niigz = fullfile(pathname,[basename '.nii.gz']);
    	ext_nii = fullfile(pathname,[basename '.nii']);

    	if exist(fname)
    		fprintf(2,'File "%s" exists but it has no extension and will be ignored in favour of "%s" or "%s"\n',fname,ext_niigz,ext_nii);
    	end
   
    	if exist(ext_niigz,'file') && exist(ext_nii,'file')
    		error(sprintf('Both "%s" and "%s" exist. Cannot unambiguously determine which file to use',ext_niigz,ext_nii));
    	elseif exist(ext_nii,'file')
    		fname = ext_nii;
    	elseif exist(ext_niigz,'file')
    		fname = ext_niigz;
    	else
    		error(sprintf('Neither "%s" nor "%s" could not be found',ext_niigz,ext_nii));
    	end
    	
    elseif ~exist(fname,'file')
    	error('File "%s" not found',fname);
    end

	nii = load_untouch_nii(fname); % Note that the volume returned by load_untouch_nii corresponds to the volume returned by FSL's read_avw
	nii = scale_image(nii);
	vol = double(nii.img);
	res = nii.hdr.dime.pixdim(2:5);
	toffset = nii.hdr.dime.toffset;
	tunit_code = int16(nii.hdr.dime.xyzt_units);
	if bitget(tunit_code,4)
		tunits = 's';
	elseif bitget(tunit_code,5)
		tunits = 'ms';
	elseif bitget(tunit_code,6)		
		tunits = 'us';
	else
		tunits = '';
	end

	if nii.hdr.hist.sform_code == 0 &&  nii.hdr.hist.qform_code == 0
		fprintf(2,'Warning - *NO* qform/sform header code is provided! Your NIFTI file is *not* usable without this information!\n')
	end

	if nii.hdr.hist.sform_code == 1
		fprintf(2,'Warning - sform code is 1 which suggests the NIFTI file may be in an unexpected coordinate system\n');
	end

	xform = eye(4);
	if nii.hdr.hist.sform_code > 0 || (nii.hdr.hist.sform_code == 0 && nii.hdr.hist.qform_code == 0)
		% Use SFORM
		xform(1,:) = nii.hdr.hist.srow_x;
		xform(2,:) = nii.hdr.hist.srow_y;
		xform(3,:) = nii.hdr.hist.srow_z;
	else
		% Use QFORM
		b = nii.hdr.hist.quatern_b;
		c = nii.hdr.hist.quatern_c;
		d = nii.hdr.hist.quatern_d;
        a = sqrt(1-b^2-c^2-d^2);
		R = [a^2+b^2-c^2-d^2  , 2*b*c-2*a*d     , 2*b*d+2*a*c;
		     2*b*c+2*a*d      , a^2-b^2+c^2-d^2 , 2*c*d-2*a*b;
		     2*b*d-2*a*c      , 2*c*d+2*a*b     , a^2-b^2-c^2+d^2;];
		xform(1,:) = [R(1,:)*nii.hdr.dime.pixdim(2) nii.hdr.hist.qoffset_x];
		xform(2,:) = [R(2,:)*nii.hdr.dime.pixdim(3) nii.hdr.hist.qoffset_y];
		xform(3,:) = [R(3,:)*nii.hdr.dime.pixdim(1)*nii.hdr.dime.pixdim(4) nii.hdr.hist.qoffset_z];
    end

    xform_codes = [nii.hdr.hist.sform_code, nii.hdr.hist.qform_code];

function nii = scale_image(nii)
	% Apply the value scaling from xform_nii.m without the transformations
	if nii.hdr.dime.scl_slope ~= 0 & ismember(nii.hdr.dime.datatype, [2,4,8,16,64,256,512,768]) & (nii.hdr.dime.scl_slope ~= 1 | nii.hdr.dime.scl_inter ~= 0)
	  nii.img = nii.hdr.dime.scl_slope * double(nii.img) + nii.hdr.dime.scl_inter;
	end

	if nii.hdr.dime.scl_slope ~= 0 & ismember(nii.hdr.dime.datatype, [32,1792])
	  nii.img = nii.hdr.dime.scl_slope * double(nii.img) + nii.hdr.dime.scl_inter;
	end

