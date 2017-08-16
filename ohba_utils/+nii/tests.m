maskdir = fullfile(osldir,'std_masks');
targetdir = '.';

% To check that the use of load_untouch_nii and save_nii is consistent:
x = read_avw(fullfile(maskdir,'MNI152_T1_8mm_brain.nii.gz'));
[y,res,xform] = nii.load(fullfile(maskdir,'MNI152_T1_8mm_brain.nii.gz'));
nii.save(y,res,xform,fullfile(targetdir,'test.nii.gz'))
z = read_avw(fullfile(targetdir,'test.nii.gz'));
all(x(:)==z(:))

% Check that nii_quicksave does what its supposed to
p = parcellation('dk_cortical.nii.gz');
p = p.remove_parcels(11:p.n_parcels);
p = p.merge_parcels({[1:10]});
f = p.savenii(p.weight_mask,'example_mask.nii.gz');
osleyes(f)

% Test saving onto standard mask
activation = randn(p.n_voxels,3); % Going to save out 3 volumes
nii.quicksave(activation,'quicksave_test');
osleyes('quicksave_test.nii.gz')

% Test interpolating it
nii.quicksave(activation,'quicksave_test_interp',struct('output_spat_res',2));
osleyes({'quicksave_test.nii.gz','quicksave_test_interp.nii.gz'})

% Test interpolating using old syntax
delete('quicksave_test_interp.nii.gz')
nii.quicksave(activation,'quicksave_test_interp',8,2,'linear');
osleyes({'quicksave_test.nii.gz','quicksave_test_interp.nii.gz'})

% Save onto the specific mask
n = sum(p.weight_mask(:)>0);
activation = randn(n,3); % Going to save out 3 volumes
nii.quicksave(activation,'quicksave_test',struct('mask_fname','example_mask.nii.gz'));
osleyes('quicksave_test.nii.gz')

% Check that tres is correct
nii.quicksave(activation,'quicksave_test',struct('mask_fname','example_mask.nii.gz','tres',5.2));
[~,res] = nii.load('quicksave_test.nii.gz');

