function fname_out = quicksave(mat,fname,options_or_input_spat_res,output_spat_res,interp)
    % Wrapper for saving a 2D matrix onto a mask, followed by interpolating
    % fname_out = nii.quicksave(mat,fname,options)
    % OR
    % fname_out = nii.quicksave(mat,fname,input_spat_res,output_spat_res,interp) - interface provided for some
    % backwards compatibility
    % 
    % Saves a niftii file for passed in data
    %
    % mat is a 2D matrix of data (nvoxels x ntpts)
    %
    % fname is the output filename
    %
    % options.output_spat_res is is output spatial resolution in mm
    % options.interp is interpolation method to use for flirt resampling, {default 'trilinear'}
    % options.tres is temporal res in secs {default 1s}
    % options.toffset is time offset in secs {default 0s}
    % options.mask_fname is niftii filename of mask used, if not passed in (or set to []) then a whole brain mask is assume
    % 
    % Note time axis is assumed to be in seconds (and the NIFTI time units will be set accordingly) 
    %
    % RA 2017
    % MWW 2015

    % First process inputs into options struct
    if nargin < 5 || isempty(interp) 
        interp = [];
    end

    if nargin < 4 || isempty(output_spat_res) 
        output_spat_res = [];
    end
    
    if nargin < 3 || isempty(options_or_input_spat_res) 
        options_or_input_spat_res = struct;
    end
    
    % If an options struct was NOT provided, then map extra inputs to struct fields
    if ~isstruct(options_or_input_spat_res)
        options = struct;
        if ~isempty(interp)
            options.interp = interp;
        end

        if ~isempty(output_spat_res)
            options.output_spat_res = output_spat_res;
        end

        options.input_spat_res = options_or_input_spat_res;
    else
        options = options_or_input_spat_res;
    end

    if ~isfield(options,'interp')
        options.interp = 'cubic'; % Default interpolation algorithm
    end

    if ~isfield(options,'tres')
        options.tres = 1;
    end

    if ~isfield(options,'toffset')
        options.toffset = 0;
    end

    if ~isfield(options,'mask_fname')
        % Assume whole brain mask if no mask is provided
        [~,options.mask_fname] = parcellation.guess_template(mat); % Try to guess whole brain input mask
    end
    
    if ~isfield(options,'input_spat_res')
        options.input_spat_res = nii.get_spatial_res(options.mask_fname);
    else
        tmp = nii.get_spatial_res(options.mask_fname);
        assert(tmp(1)==options.input_spat_res,'Option spatial resolution does not match mask resolution')
    end

    if ~isfield(options,'output_spat_res')
        options.output_spat_res = options.input_spat_res;
    end

    fname_out=[fname '.nii.gz'];

    [~,res,xform] = nii.load(options.mask_fname);
    res(4) = options.tres;
    stdbrain=nii.load(options.mask_fname); 
    stdbrain = stdbrain~=0;
    vols = matrix2vols(mat,stdbrain);
    nii.save(vols,res,xform,fname_out,'toffset',options.toffset,'tunits','s');

    if options.output_spat_res ~= options.input_spat_res
        [~,target_mask] = parcellation.guess_template(options.output_spat_res);
        nii.resample(fname_out,fname_out,target_mask,'interptype',options.interp);
    end

