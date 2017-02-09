function tseries = ViewFMRI2(Data,Mean,func,funcd,xdim,ydim,varargin)

% tseries = ViewFMRI(Data,Mean,func,funcd,varargin)
%
% Tool for viewing 4D FMRI datasets.
%
% Mean determines the data shown in the slice-by-slice lightbox.
% Mean='m' shows the mean volume.
% Mean='' shows the middle volume in the series, this is the
% default.
%
% func is function that runs on middle mouse click
% default is plotseries, which just plots the time series
% an alternative is fftseries, which plots the fft of the time series
%
% funcd is function that runs when d is pressed
% default is plotseries, which just plots the time series
% an alternative is fftseries, which plots the fft of the time series
%
% varargin are any arguments to be passed to func and funcd
%
% xdim,ydim are voxel dimensions - default 64,64

   
if (nargin<6)
   ydim=64;
   if (nargin<5)
      xdim=64;
      if (nargin<4)
         funcd = 'plotseries';
         if (nargin<3)
            func = 'plotseries';
	 end;
      end;
   end;
end;

%if size(Data,1) ~= size(Data,2)
%  error('Image matrix must be square');
%end;
%res = size(Data,1);

Index=0;
if length(size(Data))==2
  MeanImg=Data(floor(size(Data,1)/2),:);
  if (nargin>1)
    if Mean=='m'
      MeanImg=mean(Data);
    end;
  end;
  
  NumSlices=size(Data,2)/(xdim*ydim);
  Data=reshape(Data',xdim,ydim,NumSlices,size(Data,1));

else
  MeanImg=mean(Data,4);
  NumSlices=size(MeanImg,3);
  if NumSlices>21
    AllData = MeanImg;
    MeanImg = AllData(:,:,Index+1:Index+21); 
  end
  MeanImg=reshape(MeanImg,1,prod(size(MeanImg)));
end;

if NumSlices<21
  tmp=zeros(1,xdim*ydim*21);
  tmp(1:xdim*ydim*NumSlices)=MeanImg;
  MeanImg=tmp;
end;

MeanImg=reshape(MeanImg,xdim,ydim,21);

LeftPanel=zeros(7*ydim,3*xdim);
for ct1=0:2
  for ct2=0:6
    LeftPanel(1+ct2*ydim:ydim+ct2*ydim,1+ct1*xdim:xdim+ct1*xdim)=MeanImg(:,:,1+ct1+ct2*3)';
  end;
end;


HndlImg=figure;

factor=2;

colormap('bone');
Xrange=[1,xdim];
Yrange=[1,ydim];
scale=min(xdim,ydim);
ImgNum=1;Xind=1;Yind=1;  

LeftImg=subplot('position',[0.01,0.05,0.29,0.9]);
imagesc(LeftPanel);
if xdim==ydim
   axis('equal')
end;
axis('off')
if NumSlices > 21
  title(sprintf('n for next 21 slices\np for previous 21 slices'));
end;

tseries=squeeze(Data(Xind,Yind,ImgNum+Index,:));
MeanInt=mean(tseries);
subplot('position',[0.37,0.05,0.61,0.29]);    
feval(func, tseries, varargin{:});
title(sprintf('Slice %d; X: %d  Y: %d -- Mean Intensity: %5.3f ',ImgNum-1+Index,Xind,Yind,MeanInt)); 

RightImg=subplot('position',[0.37,0.41,0.4,0.55]);
imagesc(MeanImg(:,:,ImgNum)')
set(RightImg,'XLim',Xrange,'YLim',Yrange);
if xdim==ydim
   axis('equal')
end;
axis('tight')
set(RightImg,'XColor','red','YColor','red');


while 1==1
  
  TextImg=subplot('position',[0.8,0.41,0.18,0.55]);
  plot([1])
  axis('off')
  set(TextImg,'XLim',[0,2],'YLim',[0,2]);
  text(0.3,1.8,sprintf('Slice No: %2d',ImgNum-1+Index));
  text(0.3,1.6,sprintf('       X: %2d',Xind));
  text(0.3,1.4,sprintf('       Y: %2d',Yind));
  text(0.3,1.2,sprintf('Mean Intensity'));
  text(0.3,1.0,sprintf('     %5.3f',MeanInt));
  line([0.05,1.95],[0.85,0.85],'Color','black')
  text(0.05,0.7,sprintf('<left>,<right>: zoom'));
  text(0.05,0.5,sprintf('<centre>: plot tc '));
  text(0.05,0.3,sprintf('q,Q: quit'));
  text(0.05,0.1,sprintf('d,D: indiv. tc'));
  
  drawflag=1;
  
  subplot(RightImg); 
  [X_c,Y_c,B_c]=ginput(1);
  
  if gca==LeftImg	 
    
    tmp=1+floor(X_c/xdim)+3*floor(Y_c/ydim);
    if tmp<=NumSlices-Index
      ImgNum=tmp;
    else
      drawflag=0;
    end;
    
    if drawflag
      tseries=squeeze(Data(Xind,Yind,ImgNum+Index,:));
      MeanInt=mean(tseries);
      subplot('position',[0.37,0.05,0.61,0.29]);    
      feval(func, tseries, varargin{:});
      title(sprintf('Slice %d; X: %d  Y: %d -- Mean Intensity: %5.3f ',ImgNum-1+Index,Xind,Yind,MeanInt)); 
      
      RightImg=subplot('position',[0.37,0.41,0.4,0.55]);
      imagesc(MeanImg(:,:,ImgNum)')
      set(RightImg,'XLim',Xrange,'YLim',Yrange);
      title(strcat('Slice ',num2str(ImgNum-1+Index)));
      set(RightImg,'XColor','red','YColor','red');
      
      LeftImg=subplot('position',[0.01,0.05,0.29,0.9]);
      imagesc(LeftPanel);
      axis('off')
      if xdim==ydim
	 axis('equal')
      end;
      
      Corner1=1+xdim*floor(X_c/xdim);
      Corner2=1+ydim*floor(Y_c/ydim);
      line([Corner1,Corner1],[Corner2,Corner2+ydim-1]);
      line([Corner1+xdim-1,Corner1+xdim-1],[Corner2,Corner2+ydim-1]);
      line([Corner1,Corner1+xdim-1],[Corner2,Corner2]);
      line([Corner1,Corner1+xdim-1],[Corner2+ydim-1,Corner2+ydim-1]);
    end;
  end; 
  
  if gca==RightImg
    if (B_c==1)|(B_c==2)|(B_c==3) 
      if (round(X_c)>0)&(round(X_c)<=xdim)
	Xind=round(X_c);
      end;
      if (round(Y_c)>0)&(round(Y_c)<=ydim)      
	Yind=round(Y_c);
      end;
    end;
    if B_c==2
      TSImg=subplot('position',[0.37,0.05,0.61,0.29]);    
      tseries=squeeze(Data(Xind,Yind,ImgNum+Index,:));
      MeanInt=mean(tseries);
      feval(func, tseries, varargin{:});
      %title(sprintf('Slice %d; X: %d  Y: %d -- Mean Intensity: %5.3f ',ImgNum-1+Index,Xind,Yind,MeanInt)); 
    end;
    if (B_c==1)&(scale>3)
      scale=round(scale/factor);
      Xrange=[Xind-0.5*scale,Xind+0.5*scale-1];
      Yrange=[Yind-0.5*scale,Yind+0.5*scale-1];
      %%Xrange=Xrange+sum(Xrange<1)-sum(Xrange>xdim);
      %%Yrange=Yrange+sum(Yrange<1)-sum(Yrange>ydim);
      Xrange=Xrange-min(Xrange-1)*max(Xrange<1)-max(Xrange-xdim)*max(Xrange>xdim);
      Yrange=Yrange-min(Yrange-1)*max(Yrange<1)-max(Yrange-ydim)*max(Yrange>ydim);
      %%fprintf('X:%d Y:%d Xr: %d-%d Yr: %d-%d\n',Xind,Yind,min(Xrange),max(Xrange),min(Yrange),max(Yrange))
      RightImg=subplot('position',[0.37,0.41,0.4,0.55]);
      imagesc(MeanImg(:,:,ImgNum)')
      set(RightImg,'XLim',Xrange,'YLim',Yrange);
      title(strcat('Slice ',num2str(ImgNum-1+Index)));
      set(RightImg,'XColor','red','YColor','red');
    end;
    if (B_c==3)&(scale < min(xdim,ydim)-1)
      scale=round(scale*factor);
      Xrange=[Xind-0.5*scale,Xind+0.5*scale-1];
      Yrange=[Yind-0.5*scale,Yind+0.5*scale-1];
      Xrange=Xrange-min(Xrange-1)*max(Xrange<1)-max(Xrange-xdim)*max(Xrange>xdim);
      Yrange=Yrange-min(Yrange-1)*max(Yrange<1)-max(Yrange-ydim)*max(Yrange>ydim);
      RightImg=subplot('position',[0.37,0.41,0.4,0.55]);
      imagesc(MeanImg(:,:,ImgNum)');
      set(RightImg,'XLim',Xrange,'YLim',Yrange);
      title(strcat('Slice ',num2str(ImgNum-1+Index)));
      set(RightImg,'XColor','red','YColor','red');
    end;
  end;
  
  if (B_c==113)|(B_c==81)
    close(HndlImg);
    break
  end;	 
  if (B_c==68)|(B_c==100)
    figure
    feval(funcd, tseries, varargin{:});     
    %title(sprintf('Slice %d; X: %d  Y: %d -- Mean Intensity: %5.3f ',ImgNum-1+Index,Xind,Yind,MeanInt));
    figure(HndlImg);
  end;
  if (B_c==112)|(B_c==80)
    %P or p
    if (Index>0)
      Index=Index-21;
      MeanImg = zeros(xdim,ydim,21);
      MeanImg(:,:,1:min([Index+21 NumSlices])-Index) = AllData(:,:,Index+1:min([Index+21 NumSlices])); 
      LeftPanel=zeros(7*ydim,3*xdim);
      for ct1=0:2
	for ct2=0:6
	  LeftPanel(1+ct2*ydim:ydim+ct2*ydim,1+ct1*xdim:xdim+ct1*xdim)=MeanImg(:,:,1+ct1+ct2*3)';
	end;
      end;
      subplot(LeftImg);
      imagesc(LeftPanel);
      if xdim==ydim
         axis('equal')
      end;
      axis('off')
      if NumSlices > 21
	title(sprintf('n for next 21 slices\np for previous 21 slices'));
      end;
    end;
  end;
  if (B_c==110)|(B_c==78)
    %N or n
    if ((Index+21)<NumSlices)
      Index=Index+21;
      MeanImg = zeros(xdim,ydim,21);
      MeanImg(:,:,1:min([Index+21 NumSlices])-Index) = AllData(:,:,Index+1:min([Index+21 NumSlices])); 
      LeftPanel=zeros(7*ydim,3*xdim);
      for ct1=0:2
	for ct2=0:6
	  LeftPanel(1+ct2*xdim:xdim+ct2*xdim,1+ct1*ydim:ydim+ct1*ydim)=MeanImg(:,:,1+ct1+ct2*3)';
	end;
      end;
      subplot(LeftImg);
      imagesc(LeftPanel);
      if xdim==ydim
         axis('equal')
      end;
      axis('off')
      if NumSlices > 21
	title(sprintf('n for next 21 slices\np for previous 21 slices'));
      end;
    end;
  end;
end;
