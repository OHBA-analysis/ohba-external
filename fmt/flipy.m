function B=flipy(A);
%FLIPY Flip 2D,3D,4D object along y direction
%
%  B=FLIPY(A)
%
%  Tim Behrens

I1=1:size(A,2);
I2=size(A,2):-1:1;
B=zeros(size(A));
if(ndims(A)==2)
  B(:,I1)=A(:,I2);
elseif(ndims(A)==3)
  B(:,I1,:)=A(:,I2,:);
elseif(ndims(A)==4)
  B(:,I1,:,:)=A(:,I2,:,:);
else
  error('Sorry - only works for 2D,3D,4D objects')
end
