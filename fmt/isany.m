function A = isany(B,vec);
%% ISANY -- returns B==(any of the elements of vec);
%%
%% A = ISANY(B,VEC);

A=zeros(size(B));
for i=1:length(vec)
  A=A|(B==vec(i));
end
