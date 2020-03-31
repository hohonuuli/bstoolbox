function a = geocmps_(x,y,s,TTitle)
% GEOCMPS_ Compass plot using geographic angle
% 
% Use As:  geocmps_(U,V,L,T) to draw graph that displays the vectors with
%                            as arrows emanating from the origin.
% Inputs:   U = Easterly vector component
%           V = Northerly vector component
%           L = line specification example 'r-'
%           T = title as string
% Output:  pH = handle to the line objects
% 
%           geocmps_(Z) is equivalent to geocmps_(REAL(Z),IMAG(Z)). 
%
% See Also: ROSE, FEATHER, QUIVER, POLAR, GEOPOLR_, COMPASS
%
% Note: This was adapted from the MathWorks COMPASS routine to show
%       the graph in geographical sense with 0 degrees north. It
%       requires the GEOPOLR_, RAD2DEG_, MTH2GEO_ functions.

%   Charles R. Denham, MathWorks 3-20-89
%   Modified, 1-2-92, LS.
%   Modified, 12-12-94, cmt.
%   Copyright (c) 1984-97 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2005/04/13 20:38:43 $
%   5 Nov 1997; W. Broenkow revised to work with geographic angles

xx =[0 1 .95  1  .95].';
yy =[0 0 .02  0 -.02].';
arrow = xx + yy.*sqrt(-1);

if nargin == 2
   if isstr(y)
      s = y;
      y = imag(x); x = real(x);
     else
      s = [];
   end
  elseif nargin == 1
   s = [];
   y = imag(x); x = real(x);
end

x = x(:);
y = y(:);
if length(x) ~= length(y)
   error('X and Y must be same length.');
end

z  = (x + y.*sqrt(-1)).';      % Change input vectors to complex
a  = arrow * z;                % Multiply the complex vector times the arrow 
                               % But the tip of the arrow is proportional to the vector length  
L  = max(abs(a(2,:)));         % This is the length of the largest vector
                               % abs(a(3,:)-a(2,:)) this is the length of the tips
% The following attempts to normalize the length of the arrow tips using
% the magnitude of the maximum length vector. It does not work perfectly,
% and the size of the tips decreases as the vectors become shorter.
j = find(abs(a(2,:)) == 0);
if ~isempty(j)
  a(2,j) = 1;
end
a(3,:) = a(3,:) + L*(a(3,:) - a(2,:))./abs(a(2,:));  % Normalize tip of arrow  
a(5,:) = a(5,:) + L*(a(5,:) - a(2,:))./abs(a(2,:));  % but not by zero

next = lower(get(gca,'NextPlot'));   
isholdon = ishold;                   
  [th,r] = cart2pol(real(a),imag(a));
  thdegs = mth2geo_(rad2deg_(th));   % GEOPOLR_ requires angles input in degrees
if isempty(s),
   h = geopolr_(thdegs,r);           % Use our GEOPOLR_ function instead of POLAR
  co = get(gca,'colororder');        % to do the plottng.
  set(h,'color',co(1,:))
else
  if exist('TTitle')
    h = geopolr_(thdegs,r,s,TTitle); % Use our GEOPOLR_ function instead of POLAR
  else
    h = geopolr_(thdegs,r,s);
  end
end
if ~isholdon, set(gca,'NextPlot',next); end
if nargout > 0
   pH = h;
end
