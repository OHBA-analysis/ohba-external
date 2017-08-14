function mat = nii_quickread(fileName, spatialRes)
%NII_QUICKREAD reads nifti files and converts from a volume to a matrix. 
%
% A = NII_QUICKREAD(FILENAME, SPATIALRES) reads nifti file FILENAME, stored
%   with a grid spacing of SPATIALRES mm, into 2D matrix A. 
%
%   3D Nifti files are read into a column vector, 4D Nifti files into a 
%   2D matrix whose columns hold separate volumes. 
%
% See also: nii.quicksave. 

% (c) OHBA 2014

OSLDIR = getenv('OSLDIR');

% check for existence of input file
if ~exist(fileName,             'file') && ...
   ~exist([fileName '.nii'],    'file') && ...
   ~exist([fileName '.nii.gz'], 'file'),

    error([mfilename ':FileNotFound'], ...
          'File %s was not found. \n', fileName);
end

% check spatial resolution is integer value
if mod(spatialRes, 1), 
    error([mfilename ':NonIntegerSpatialRes'], ...
          'Spatial resolution %f not valid. Expecting an integer. \n', ...
          spatialRes);
end

stdBrainName = fullfile(OSLDIR, 'std_masks', sprintf('MNI152_T1_%0.0fmm_brain.nii.gz', spatialRes));

% if unusual spatial resolution, create a temporary mask
if ~exist(stdBrainName, 'file'), 
    nii.resample(fullfile(OSLDIR, 'std_masks','MNI152_T1_2mm_brain.nii.gz'), stdBrainName, spatialRes);
    C = onCleanup(@() delete(stdBrainName));
end

maskmat = nii.load(stdBrainName);
maskmat = maskmat~=0;
mat = vols2matrix(nii.load(fileName), maskmat);

end