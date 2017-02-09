function [x, options] = gslinemin(f, pt, dir, fpt, options, varargin)
%LINEMIN One dimensional minimization.
%
%	Description
%	[X, OPTIONS] = LINEMIN(F, PT, DIR, FPT, OPTIONS) uses Brent's
%	algorithm to find the minimum of the function F(X) along the line DIR
%	through the point PT.  The function value at the starting point is
%	PT.  The point at which F has a local minimum is returned as X.  The
%	function value at that point is returned in OPTIONS(8).

% Check function string
f = fcnchk(f, length(varargin));

% Value of golden section (1 + sqrt(5))/2.0
phi = 1.6180339887499;
cphi = 1 - 1/phi;
TOL = 1e-6;	% Maximal fractional precision
TINY = 1.0e-10;         % Can't use fractional precision when minimum is at 0

br_min=-10;
br_mid=0;
br_max=10;				
pt=1e-10;
dir=1;

% Use Brent's algorithm to find minimum
% Initialise the points and function values
w = br_mid;   	% Where second from minimum is
v = br_mid;   	% Previous value of w
x = v;   	% Where current minimum is
e = 0.0; 	% Distance moved on step before last

fx = feval('linef', x, f, pt, dir, varargin{:});
%fx=logsigg2function(pt+x*dir,varargin{:});
options(10) = options(10) + 1;
fv = fx; fw = fx;
prec=0.0001;

niters=100;

for n = 1:niters
  xm = 0.5*(br_min+br_max);
  % Make sure that tolerance is big enough

  tol1 = TOL * (abs(x)) + TINY;
  % Decide termination on absolute precision required by options(2)
  if (max(abs(x - xm)) <= prec & br_max-br_min < 4*prec)
    return;
  end
  % Check if step before last was big enough to try a parabolic step.
  % Note that this will fail on first iteration, which must be a golden
  % section step.
  if (abs(e) > tol1)
    % Construct a trial parabolic fit through x, v and w
    r = (fx - fv) * (x - w);
    q = (fx - fw) * (x - v);
    p = (x - v)*q - (x - w)*r;
    q = 2.0 * (q - r);
    if (q > 0.0) p = -p; end
    q = abs(q);
    % Test if the parabolic fit is OK
    if (abs(p) >= abs(0.5*q*e) | p <= q*(br_min-x) | p >= q*(br_max-x))
      % No it isn't, so take a golden section step
      if (x >= xm)
        e = br_min-x;
      else
        e = br_max-x;
      end
      d = cphi*e;
    else
      % Yes it is, so take the parabolic step
      e = d;
      d = p/q;
      u = x+d;
      if (u-br_min < 2*tol1 | br_max-u < 2*tol1)
        d = sign(xm-x)*tol1;
      end
    end
  else
    % Step before last not big enough, so take a golden section step
    if (x >= xm)
      e = br_min - x;
    else
      e = br_max - x;
    end
    d = cphi*e;

  end
  
  % Make sure that step is big enough
  if (abs(d) >= tol1)
    u = x+d;
  else
    u = x+sign(d)*tol1;
  end
  % Evaluate function at u
  fu = feval('linef', u, f, pt, dir, varargin{:});
  %fu=logsigg2function(pt+u*dir,varargin{:});

  options(10) = options(10) + 1;
  % Reorganise bracket

  if (fu <= fx)
    if (u >= x)
      br_min = x;
    else
      br_max = x;
    end
    v = w; w = x; x = u;
    fv = fw; fw = fv; fx = fu;
  else
    if (u < x)
      br_min = u;   
    else
      br_max = u;
    end
    if (fu <= fw | w == x)
      v = w; w = u;
      fv = fw; fw = fu;
    elseif (fu <= fv | v == x | v == w)
      v = u;
      fv = fu;
    end
  end

end

