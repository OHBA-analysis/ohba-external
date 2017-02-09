function [m,bars]=fmt_mode(data,dim,bins);
% Mode - find the of some data;
%
% M=FMT_MODE(DATA);
%
% Mode along the 1st non-singular dimension with automatic binning; 
%
% M=FMT_MODE(DATA,DIM)
%
% Mode along dimension DIM - automatic binning 
%
% M=FMT_MODE(DATA,DIM,BINS)
%
% Mode along dimension DIM with prescribed binning.
% BINS can be number of bins required, or vector prescribing
% exact bins, as in HIST
%
% TB 

if(nargin<2)
  [b,n]=shiftdim(data);
  dim=1+n;
end

if(nargin<3)
  num=max(5,round(size(data,dim)/100));
  Min=percentile(data,1);
  Max=percentile(data,99);
  step=(Max-Min)/(num-1);
  bins=Min:step:Max;
end


if(size(data,dim)==1)
  error('mode along a singleton direction?? Clever!');
end


nd=ndims(data);
sd=size(data);
data2=shiftdim(data,nd-dim);
sd2=size(data2);
nd2=ndims(data2);
data2=reshape(data2,prod(sd2(1:nd2-1)),sd2(nd2));
data2=shiftdim(data2,1);
[bars,x]=hist(data2,bins);
[m,I]=max(bars);
m=x(I);
sd(dim)=[1];
m=reshape(m,sd);






