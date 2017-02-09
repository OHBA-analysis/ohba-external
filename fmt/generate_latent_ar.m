function [x, arcoeff, sarx, sary, sarz] = generate_latent_ar(Nx, Ny, Nz, T, arcoeff, sarx, sary, sarz, sdevs, mn, activation, regressor)

% x_t=s_t+e_t
% s_t=a*s_t-1+n_t
% N=7; T=180; order=3; [x, ars, sarx, sary, sarz] = generate_latent_ar(N,N,1,T, [0.2 0.1 0], 0.1, 0.1, 0, 100, 1000, 0, 0); save_avw(x,'/home/fs0/woolrich/bpm/data/art_ar3_small','s',[4 4 7 3]); save_avw(arcoeff,'/home/fs0/woolrich/bpm/data/arcoeff_ar3','s',[4 4 7 3]); 

if(length(size(arcoeff))<3),
  if(size(arcoeff,1)==1)arcoeff=arcoeff';end;
  order=max(size(arcoeff))
  arcoeff=reshape(shiftdim(reshape(repmat(arcoeff,Nx*Ny*Nz,1),order,Nx,Ny,Nz),1),Nx,Ny,Nz,order);
else
  order=size(arcoeff,length(size(arcoeff)));
end;

%arcoeff = randn(Nx,Ny,Nz,order)*0.1;

if(prod(size(sarx))==1), sarx = randn(Nx,Ny,Nz)*sarx; end;
if(prod(size(sary))==1), sary = randn(Nx,Ny,Nz)*sary; end;
if(prod(size(sarz))==1), sarz = randn(Nx,Ny,Nz)*sarz; end;
if(prod(size(sdevs))==1), sdevs = ones(Nx,Ny,Nz)*sdevs; end;
if(prod(size(activation))==1), activation = ones(Nx,Ny,Nz)*activation; end;
if(prod(size(regressor))==1), regressor = zeros(T,1); end;

%x = randn(Nx,Ny,Nz,T);
x = zeros(Nx,Ny,Nz,T);
s = zeros(Nx,Ny,Nz,T);

for t = 1:T,
for i = 1:Nx,
for j = 1:Ny,
for k = 1:Nz,

  s(i,j,k,t) = activation(i,j,k)*regressor(t) + randn*sdevs(i,j,k);

  if t > 1,
   if(i>1) s(i,j,k,t) = sarx(i-1,j,k)*s(i-1,j,k,t-1) + s(i,j,k,t); end;
   if(i<Nx) s(i,j,k,t) = sarx(i,j,k)*s(i+1,j,k,t-1) + s(i,j,k,t); end;
   if(j>1) s(i,j,k,t) = sary(i,j-1,k)*s(i,j-1,k,t-1) + s(i,j,k,t); end;
   if(j<Ny) s(i,j,k,t) = sary(i,j,k)*s(i,j+1,k,t-1) + s(i,j,k,t); end;
   if(k>1) s(i,j,k,t) = sarz(i,j,k-1)*s(i,j,k-1,t-1) + s(i,j,k,t); end;
   if(k<Nz) s(i,j,k,t) = sarz(i,j,k)*s(i,j,k+1,t-1) + s(i,j,k,t); end;

   for a = 1 : order,
	if t > a,
           s(i,j,k,t) = arcoeff(i,j,k,a)*s(i,j,k,t-a) + s(i,j,k,t);
           x(i,j,k,t) = s(i,j,k,t) + x(i,j,k,t);
	end;
   end;
  end;
end;
end;
end;
end;

%x(2:Nx-1,2:Ny-1,:) = x(2:Nx-1,2:Ny-1,:)+mn;

x = x+mn;