function [fh,ah] = plot_activation(self,activation,clim)
	% Render spatial maps in slices
	%
	% INPUTS
	% - activation - matrix of activation values (parcels x 1, voxels x 1, or XYZ x 1)
	% - clim - colour range for plot
	%
	% The colour limit supports a number of different options
	% clim = [low high] -> absolute values for the correlations plotted, red/blue discontinuous colormap (cf. Adam)
	% clim = [0 high] -> absolute values for correlations, red-white-blue colourmap
	% clim = 0 -> automatic maximum correlation, symmetric red-white-blue colourmap 
	% clim = 0.5 -> automatic maximum correlation for each state, value is the low cutoff as a fraction of the maximum, red/blue discontinuous colormap 
	% clim = [] -> same as clim = 0.6 (equivalent to the eLife paper colour scheme)
	%
	% NB. For most of what we do, these figures agree with FSLVIEW which means they are in 
	% radiological view, with the left side of the brain appearing on the right side of the plot
	% If in doubt, check with FSLVIEW

	if isvector(activation)
		activation = self.to_vol(activation);
	end

	% Apply spatial smoothing
	activation(~isfinite(activation)) = 0;
	activation = smooth3(activation,'gaussian',5,1); % Apply spatial smoothing

	mask = self.template_mask;

	if nargin < 3 || isempty(clim) 
		clim = 0.6;
	end
	
	if length(clim) == 1
		if clim == 0
			clim = [0 0.01]+[0 1]*max(abs(activation(:))); % Auto upper bound, inclimuding zero
		else
			clim = [0 0.01]+[clim 1]*max(abs(activation(:))); % If only one value is provided
		end
	else
		clim = clim;
	end
	

	assert(all(size(activation)==size(mask)),'Activation is not the same size as the mask')
	slices_to_plot = find(squeeze(sum(sum(mask>0,1),2)));
	background = mask./max(mask(:));

	% Get the colour function - map activation to RGB colour
	if clim(1) == 0
		% Original - colour, no transparency
		colour_fcn = dynamic_cmap('rwb',[-clim(2) clim(2)]);
		alpha_fcn = @(x) ones(size(x));

		% Alternative - solid colours, transparency indicates level
		% positive = @(x) repmat([1 0 0],length(x),1);
		% negative = @(x) repmat([0 0 1],length(x),1);
		% colour_fcn = merge_cmaps(positive,negative,clim);
		% alpha_fcn = @(x) +(abs(x)./max(abs(x(:)))); 
	else
		positive = dynamic_cmap('red',clim);
		negative = dynamic_cmap('blue',-clim);
		colour_fcn = merge_cmaps(positive,negative,clim);
		alpha_fcn = @(x) ones(size(x)); % Note NaNs are transparent by default already, so this just guarantees that any coloured pixels are opaque
	end

	% Render each slice
	img = zeros([size(mask,1) size(mask,2) 3 length(slices_to_plot)]);
	for j = 1:length(slices_to_plot)
		img(:,:,:,j) = render_slice(background(:,:,j),activation(:,:,slices_to_plot(j)),colour_fcn,alpha_fcn);
	end

	img = img(:,:,:,end:-1:1); % In the montage, put the top slices at the top of the frame
	img = imrotate(img,90);
	img = imresize(img,10); % Useful for working with 8mm masks
	fh = figure;
	ah = axes(fh);

	set(fh,'Color','k')
	montage(img)

	ah = findobj(fh,'type','axes');

	c_range = linspace(0,clim(2),100).';
	c_range = [-c_range(end:-1:2);c_range];
	c = colour_fcn(c_range);
	% c = ones(size(c_range,1),3);
	% c(c_range<-clim(1),:) = negative(c_range(c_range<-clim(1)));
	% c(c_range>clim(1),:) = positive(c_range(c_range>clim(1)));
	colormap(ah,c);
	cbar=colorbar(ah,'Color','w');
	set(ah,'CLim',[-clim(2) clim(2)])
	% ylabel(cbar,'Partial correlation','FontSize',16)
	set(cbar,'YTick',unique([linspace(-clim(2),-clim(1),4) linspace(clim(1),clim(2),4) ]))
	
end

function fn = merge_cmaps(positive,negative,clim)
	% Return a single function fn(x) that returns RGB values for 
	% VECTOR activation x that can be positive or negative
	% Returns NaN in the gap

	% If there is a gap in the colourmap, make a new function

	function rgb = eval_colour(x,postive,negative,clim)
		if ~isvector(x)
			error('Input activations must be a vector. Nx1 in, Nx3 out')
		end

		pos = positive(x); % RGB values for all positive pixels
		neg = negative(x); % RGB values for all negative pixels
		rgb = nan(length(x),3);
		rgb(x > clim(1),:) = pos(x > clim(1),:);
		rgb(x < -clim(1),:) = neg(x < -clim(1),:);
	end

	fn = @(x) eval_colour(x,positive,negative,clim); % Return the colour function

end

function img = render_slice(background,activation,cfun,afun)
	% Take in a 2D slice of background, activation, and mapping functions for colour and alpha
	% Return a single image
	activation = squeeze(activation);

	% Compute the colours associated with the activation
	rgb = cfun(activation(:));
	rgb = cat(3,reshape(rgb(:,1),size(activation)),reshape(rgb(:,2),size(activation)),reshape(rgb(:,3),size(activation)));

	alphavals = afun(activation);

	% Render the final image
	img = imrender(rgb,background,alphavals,background~=0);
end

function img = imrender(rgb,background,alphavals,mask)
	% Render a composite image by superimposing two images with transparency
	%
	% INPUT
	% - rgb = MxNx3 matrix of activation colour
	% - background = MxNx3 or MxN matrix of background colour or intensity
	% - alphavals = optional MxN alpha values for rgb from 0 to 1
	% - mask = optional MxN mask for rgb set to 0 or 1 (alphavals=0 where mask=1)
	%
	% OUTPUT
	% - img = MxNx3 image

	% If no mask, assume every pixel in rgb is wanted
	if nargin < 4 || isempty(mask) 
		mask = ones(size(rgb,1),size(rgb,2));
	end

	% If no alphavals, assume rgb is fully opaque (will still be transparent if NaNs present)
	if nargin < 3 || isempty(alphavals) 
		alphavals = ones(size(rgb,1),size(rgb,2));
	end
	
	% Convert mask to alpha
	alphavals(mask==0) = 0;

	% Clip alpha
	alphavals(alphavals < 0) = 0;
	alphavals(alphavals > 1) = 1;

	% If there are any NaNs, mask them out by setting alpha=0
	nans = isnan(rgb);
	nan_coord = any(nans,3);
	alphavals(nan_coord) = 0; % Hide them
	rgb(nans) = 0; % Give them a real value so they are OK when blended

	% Convert greyscale background into RGB values
	if ndims(background) == 2
		background = cat(3,background,background,background);
	end

	% Render the final image
	img = nan(size(rgb));
	img(:,:,1) = rgb(:,:,1).*alphavals + background(:,:,1).*(1-alphavals);
	img(:,:,2) = rgb(:,:,2).*alphavals + background(:,:,2).*(1-alphavals);
	img(:,:,3) = rgb(:,:,3).*alphavals + background(:,:,3).*(1-alphavals);
end

function genfcn = dynamic_cmap(colors,value_range)
	% Return a function that takes in a Z value and returns an RGB triplet

	if ischar(colors)
		switch(colors)
		case 'blue'
			colors = [;...
			-1 0.00  0.00 0.75;...
			 0    0.00  0.00 0.75;...
			 0.25 0.125 0.25 0.875;...
			 0.5  0.25  0.50 1.00;...
			 0.75 0.375 0.75 1.00;...
			 1    0.50  1.00 1.00;...
			 2  0.50  1.00 1.00];
		case 'red'
			colors = [;...
			-1    1.00 0.00 0.25;...
			 0    1.00 0.00 0.25;...
			 0.25 1.00 0.25 0.25;...
			 0.5  1.00 0.50 0.25;...
			 0.75 1.00 0.75 0.25;...
			 1    1.00 1.00 0.25;...
			 2    1.00 1.00 0.25];
		case 'rwb'
			colors = [;...
			-2    0.00 0.00 1.00;...
			-1    0.00 0.00 1.00;...
			 0    1.00 1.00 1.00;...
			 1    1.00 0.00 0.00;...
			 2    1.00 0.00 0.00];
		otherwise
			error('Unknown scheme')
		end
    end

    colors(:,1) = (colors(:,1)-colors(1,1));
    colors(:,1) = colors(:,1)/(colors(end,1)-colors(1,1));
    colors(:,1) = colors(:,1)*diff(value_range)+value_range(1);

    if diff(value_range) < 0 % The lowest number corresponds to the lightest color
    	colors = colors(end:-1:1,:);
    end
    
	R = griddedInterpolant(colors(:,1),colors(:,2),'linear');
	G = griddedInterpolant(colors(:,1),colors(:,3),'linear');
	B = griddedInterpolant(colors(:,1),colors(:,4),'linear');

	genfcn = @(x) [R(x) G(x) B(x)];
end


	


