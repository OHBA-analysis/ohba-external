function TF = isin(a,roi);
% ISIN return 1 if a is in roi else 0 
%
% e.g  TF = ISIN([1 2 1],[0 0 0;10 10 10]); returns 1
% but  TF = ISIN([1 20 1],[0 0 0;10 10 10]); returns 0
% works with vectors of any length.
%
% copyright (C) T.Behrens 2001

TF=(repmat(roi(1,:),size(a,1),1)<a&a<repmat(roi(2,:),size(a,1),1));
TF=floor(sum(TF,2)/size(TF,2));  