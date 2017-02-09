function ms = lmsfn(p)
% ms = lmsfn(p)
% use global variables xlms and ylms
global xlms ylms
% return the median of (ylms - p1*xlms - p2)^2
ms = median((ylms - p(1)*xlms - p(2)).^2);
