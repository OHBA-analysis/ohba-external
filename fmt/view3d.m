function view3d(vol,x,y,z);
% VIEW3D - Show 3D sliced view of a volume
%
%  VIEW3D(VOL,X,Y,Z)
%  VOL is volume
%  X is sagittal slice number
%  Y is coronal slice number
%  Z is axial slice number
%
% copyright (C) T.Behrens 2001

sagittal=squeeze(vol(x,:,:));
coronal=squeeze(vol(:,y,:));
axial=squeeze(vol(:,:,z));

sag=surf(sagittal/1000000+x,sagittal,'linestyle','none');
FVCsag=surf2patch(sag);
FVCsag1=FVCsag;
FVCsag1.vertices(:,1)=FVCsag.vertices(:,3);
FVCsag1.vertices(:,3)=FVCsag.vertices(:,1);
delete(sag);

cor=surf(coronal'/1000000+y,coronal','linestyle','none');
FVCcor=surf2patch(cor);
FVCcor1=FVCcor;
FVCcor1.vertices(:,2)=FVCcor.vertices(:,3);
FVCcor1.vertices(:,3)=FVCcor.vertices(:,2);
delete(cor);

ax=surf(axial'/1000000+z,axial','linestyle','none');
FVCax=surf2patch(ax);
delete(ax);

colormap('bone'); hold on;
patch(FVCsag1,'linestyle','none');
patch(FVCcor1,'linestyle','none');
patch(FVCax,'linestyle','none');
shading faceted; view(3)







