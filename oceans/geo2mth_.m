function mdeg = geo2mth_(geod) 
% GEO2MTH_ - Converts an angle (degrees) in geographic notation to math notation 
%  
% Use As:   mthang = geo2mth_(geoang) 
% 
% Input:    geoang  = geographic angle (0 to 360 degrees) 
% Output:   mthang  = angle in math notation  (0 to +/-180 degrees) 
% 
% Example:  geo2mth_([0:30:360]) ->
%           90 60 30  0 -30 -60 -90 -120 -150 180 150 120 90
% 
% See Also: MATH2GEO 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 10 Jun 97; W. Broenkow keeping it simple & vectorized 
 
     mdeg  = 90 - rem(geod,360); 
      ineg = find(mdeg <= -180); 
mdeg(ineg) = mdeg(ineg) + 360; 
 
 
 
