function [d, t, x] = stochastic_design(tr, meanisi, minisi, res, n, isidist, threecolfile, ttp, hrfextent, stim_duration) 

% function [d, t] = stochastic_design(tr, meanisi, minisi,
% resolution, numscans, isidist, threecolfile, ttp, hrfextent, stim_duration)
%
% tr, meanisi, minisi, resolution in time units.
%
% n is the number of tr
%
% isidist should be 3 for fixed isi designs
%
% isidist should be 2 for poisson isi designs
%
% isidist should be 1 for uniform isi designs, the
% isi's are sampled from uniform distribution U(minisi, meanisi+(meanisi-minisi))
% and no values less then minisi get used.
%
% isidist should be 0 for normal distribution isi designs
% the isi's are sampled from N(meanisi, meanisi)
% and no values less then minisi get used.
%
% Returns vector d of ones and zeros and time vector t
% and efficiency = 1/variance(b) = 1/inv(d'*d);
% If threecolfile ~= '' then writes out the design in FEAT's 3 column format
% to a file specified by threecolfile.

if(nargin<7),threecolfile = '';end;
if(nargin<8),ttp = 0;end;
if(nargin<9),hrfextent = 0;end;
if(nargin<10),stim_duration = 0.1;end;

if isidist == 0,
  rs = randn(round(4*n*tr/meanisi),1)*(sqrt(meanisi)) + meanisi;
elseif isidist == 1,
  %rs = (rand(round(4*n*tr/meanisi),1)-0.5)*(sqrt(meanisi)) + meanisi;
  rs = (rand(round(4*n*tr/meanisi),1)-0.5)*(meanisi-minisi)*2 + meanisi;
elseif isidist == 2,
  rs = poissrnd(meanisi,round(4*n*tr/meanisi),1);
elseif isidist == 3,
  rs = ones(round(4*n*tr/meanisi),1)*meanisi;
end;

rs2 = rs(find(rs >= minisi));

if(ttp>0), 
  
    if(0)
       rs2(2:2:end) = rand(length(rs2(2:2:end)),1)*(ttp-4)+4;
       rs2(1:2:end) = rand(length(rs2(1:2:end)),1)*tr+hrfextent;
    else,
       N = 2*n*tr/minisi;
       rs2 = zeros(N,1);
    for i=1:N,
        if(rand>0.5) 
           rs2(i) = rand*(ttp-minisi)+minisi;
       else
           rs2(i) = rand*tr+hrfextent;
        end;
    end;
    
end;
end;

crs2=cumsum(rs2);

[i,j]=find((crs2+stim_duration)>tr*n);
%rs2(i(1))=tr*n-crs2(i(1)-1);
rs3=rs2(1:i(1)-1);

x=zeros(length(rs3),3);
x(:,1) = cumsum(rs3);
x(:,2)=stim_duration;
x(:,3)=1;

if(~strcmp(threecolfile,'')),
fid = fopen(threecolfile,'w');
fprintf(fid,'%6.4f  %6.2f %6.2f\n',x');
fclose(fid);
end;

t = [res:res:n*tr];

d=threecol2ev(x,res,n*tr);

%d = zeros(n*tr/res,1);
%crs3 = cumsum(rs3);
%d(round(crs3/res)) = 1;
