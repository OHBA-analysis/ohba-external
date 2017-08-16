function [ mni_res ] = get_spatial_res( mask_fname )
    % Return the 3 XYZ pixel dimensions from a NIFTI file
    %
    % MWW 
    % RA
    
    [~,res] = nii.load(mask_fname);
    mni_res = abs(res(1:3));
