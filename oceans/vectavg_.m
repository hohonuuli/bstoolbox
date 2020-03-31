function [MAG,DIRECT] = vectavg_(mag,direct,option) 
% VECTAVG_ - Vector average magnitude and direction (degrees geographic) 
% 
% Use As:  [MAG,DIRECT] = vectavg_(mag,direct,option) 
%
% Input:   mag    = vector of magnitudes 
%          direct = vector of directions in degrees true (0 = N, 90 = E, 180 = S, 270 = W) 
%          option = 0 for vector average
%                   1 for vector sum 
%                   2 for cumulative vector sum 
% Output:  MAG    = vector average magnitude or (vector sum depending on flag) 
%          DIRECT = vector averaged geographic direction 
% 
% Example: mag    = [20 30 10 5];direct  = [60 200 130 270];
%          [m,d]  = vectavg_(mag,direct,0) -> m = 6.6170  d = 158.4541
%          [m,d]  = vectavg_(mag,direct,1) -> m = 26.4682 d = 158.4541   
%          [m,d]  = vectavg_(mag,direct,2) -> m = 20.00 19.51 28.68 26.46
%                                             d = 60.00 158.8 149.1 158.5

% See Also: MTH2GEO_, GEO2MTH_, RAD2DEG_, DEG2RAD_ 
 
% 10 June 1997; W. Broenkow and S. Flora with thanks to Brian Schlinning 
% 10 Nov 1997; fixed it so it works
 
if nargin < 3 
  option = 0; 
end 
if nargin < 2 
  help vectavg 
  return 
end 
 
% Convert polar coordinates in geographic direction  
% NOTE output y,x is reversed to use geographic coordinates 
[y,x] = pol2cart(deg2rad_(geo2mth_(direct)),mag); 
 
if option == 0
  [th,MAG] = cart2pol(nanmean(y),nanmean(x));    % vector average 
elseif option == 1 
  [th,MAG] = cart2pol(nansum(y),nansum(x));      % vector sum 
elseif option == 2
 k = ~isnan(y) & ~isnan(x);
 [th,MAG] = cart2pol(cumsum(y(k)),cumsum(x(k))); % cumulative vector sum 
end

DIRECT = mth2geo_(rad2deg_(th)); 
