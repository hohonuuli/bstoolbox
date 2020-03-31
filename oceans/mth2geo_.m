function gdeg = mth2geo_(mdeg) 
% MTH2GEO_ - Convert math angle in degrees to geographic 
% 
% Use As:   geoangle = mth2geo_(mathangle) 
% 
% Input:    math angle       = angle from 0 to +-180 degrees counter-clockwise 
% Output:   geographic angle = angle from 0 to 360 degrees clockwise  
% 
% Example:  mth2geo_([0:30:360]) ->
%           90 60 30  0 330 300 270 240 210 180 150 120 90
% 
% See Also: GEO2MATH_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 31 Oct 1995; W. Broenkow 
% 10 Jun 1997; added rem(mdeg,360) 
 
      mdeg = rem(mdeg,360); 
      gdeg = 90 - mdeg; 
      ineg = find(gdeg < 0); 
gdeg(ineg) = gdeg(ineg) + 360; 
 
