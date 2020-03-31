function [mp] = meridn1_(lat) 
 
% MERIDN1_ - Meridional parts for sphere to calculate rhumb-line distance and make Mercator charts 
% 
% Use As:    mp  = meridn1_(lat) 
% Input:     lat = Latitude (decimal degrees) 
% Output:    mp  = Meridional parts (minutes of latitude per degree longitude) 
% Example:   meridn1_(45) -> 3029.9 
%  
% See Also:  MERIDIN2.M, INVMERID.M, MRCTRMAP.M, rhumbl_.M, DEADRCKN.M 
 
% Perfect agreement with H.O. 9 Table 5 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 3 Aug 96; W. Broenkow annotation reversed names of meridin1.m and meridn2_.m 
% 12 Feb 97; S. Flora; added checking lat 
% 3437.747 = radius of sphere with volume equivalent to oblate spheroid 
% log(tan(pi/4 + lat/2)) = integral(1/cos(lat)dlat 
 
if any(abs(lat) > 90) 
  disp('MERIDN1_ ERROR: (Latitude is greater than 90)') 
  mp = NaN; 
  return 
end 
 
mp = 3437.747*log(tan((45+lat./2)*(pi/180))); 
