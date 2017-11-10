classdef study < handle

	properties
		path_prefix = '';
		fnames = {};
		montage = [];
		readfcn = []; % Run this function on every read after setting the target montage
		subjects = {};
		subject_mapping = [];
	end

	properties(Dependent)
		n
		n_subjects
	end

	methods

		function a = get.n(self)
			a = length(self.fnames);
		end

		function a = get.n_subjects(self)
			a = length(self.subjects);
		end

		function self = study(p,montage)
			if nargin < 2 || isempty(montage) 
				montage = [];
			end
			
			self.path_prefix = p;
			self.montage = montage;
			f = dir(fullfile(p,'*.dat'));
			for j = 1:length(f)
				self.fnames{j} = f(j).name;
			end

			try
				for j = 1:self.n
					[~,b] = fileparts(self.fnames{j});
					a(j,:) = regexp(b,'[\_\- ]','split');
				end

				n_unique = zeros(1,size(a,2));
				for j = 1:size(a,2)
					n_unique(j) = length(unique(a(:,j)));
				end
				[~,idx] = max(n_unique);
				[self.subjects,~,self.subject_mapping] = unique(a(:,idx));
			catch ME
				fprintf(2,'Could not infer subject IDs - error was "%s"\n',ME.message);
			end

		end

		function m = readall(self)
			% Return a cell array of MEEGs
			m = cell(self.n,1);
			for j = 1:self.n
				fprintf('Reading %d of %d\n',j,self.n)
				m{j} = self.read(j);
			end
		end

		function m = readsubject(self,idx,subidx)
			% Return records for a particular subject
			% idx - subject idx (in study.subjects)
			% subidx - pick just one of the recordings e.g. readsubject(1,2) is second recording for first subject
			% if empty, read and return all subjects
			% If subidx is specified, return an MEEG
			% Otherwise, return a cell array of MEEGs
			if nargin < 3 || isempty(subidx) 
				subidx = [];
			end
			
			if isstr(idx)
				idx = find(strcmp(idx,self.subjects));
			end

			assert(isempty(subidx) || isscalar(subidx));

			recidx = find(self.subject_mapping == idx);
			if ~isempty(subidx)
				recidx = recidx(subidx);
				m = self.read(recidx);
			else
				m = cell(length(recidx),1);
				for j = 1:length(recidx)
					fprintf('Reading %d of %d\n',j,length(recidx))
					m{j} = self.read(recidx(j));
				end
			end
		end


		function D = read(self,idx)
			% Read subject number idx
			% idx can be negative in which case is in interpreted as an index from the end
			% like in python e.g.
			% idx = -1 corresponds to the last item, idx =-2 the second last etc.
			if idx < 0
				idx = self.n+idx-1; 
			end
			%assert(idx > 0 & idx <= self.n,'Index must be between 1 and %d',self.n)
			
			D = spm_eeg_load(fullfile(self.path_prefix,self.fnames{idx}));

			if ~isempty(self.montage) 
				if isnumeric(self.montage) && isfinite(self.montage)
						D = D.montage('switch',self.montage);
				elseif isstr(self.montage)
					[a,b] = has_montage(D,self.montage);
					if a == 1
						D = D.montage('switch',b);
					else
						has_montage(D)
						error(sprintf('Must match exactly one montage (%s)',self.montage));
					end
				end
			end

			if isa(self.readfcn,'function_handle')
				D = self.readfcn(D);
			end

		end

	end

end
