function [lat2,lon2] = deadrkn_(lat1,lon1,dist,course,option) 
% DEADRKN_ - Determine 'dead reckoning' position from present position,  
%            distance travelled and course 
% 
% Position is extrapolated using a rhumbline which appears as a straight line 
% on a Mercator chart, but it is not necessarily the shortest distance between 
% two points on a sphere.   
% 
% Use As:  [lat2,lon2] = deadrkn_(lat1,lon1,dist,course) 
% 
% Input:   lat1   = starting latitude      (degrees) 
%          lon1   = starting longitude     (degrees) 
%          dist   = distance travelled     (n. miles) 
%          course = heading                (degrees true) 
%          option = use of different mid-latitudes read code for usage
% Output:  lat2   = latitude  of dead reckoning position 
%          lon2   = longitude of dead reckoning position 
% 
% Example:  [lat2,lon2] = deadrkn_(30,120,100,45) 
%                  lat2 =  31.1785 
%                  lon2 = 121.3691 
% 
% See Also: GCIRCLE_, MERIDN1_, MERIDN2_, MRCTMAP_, RHUMBL_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
%  3 Aug 96; W. Broenkow; based on algorithms in J.E.D. Williams (1994) 'From Sails to Satellites' 
%                         Oxford Univ. Press Chapter 3:  Meridional Parts 
 
if nargin < 5 
  option = 1; 
end 
opti = find(option==[1:4]); 
if length(opti) == 0 
  option = 1;   
end 
if nargin < 4 
  disp('DEADRKN_ ERROR: 4 input arguments required lat1,lon1,dist,course') 
  break 
end 
 
if course == 0 
  lon2 = lon1; 
  lat2 = lat1 + (dist/60); 
  return 
end 
if course == 180 
  lon2 = lon1; 
  lat2 = lat1 - (dist/60); 
  return 
end 
 cr   = deg2rad_(geo2mth_(course));        % course in radians 
 dlat = cos(cr).*(dist/60); 
lat2 = lat1 + dlat; 
if option == 1;                            % this correctly uses the mid-latitude based on meridional parts 
  c1 = cos(deg2rad_(lat1));               
  c2 = cos(deg2rad_(lat2));                % Williams says to divide by meridional parts... wrong ??? 
  mc = 1/((1/c1 + 1/c2)/2);                % cos of midlat from mean secants 
  midlat_a = rad2deg_(acos(mc));           % average the secants of lat1 and lat2 
  mp1 = meridn1_(lat1); 
  mp2 = meridn1_(lat2); 
  midlat_b = invmerd_((mp1+mp2)/2); 
  midlat = (midlat_a + midlat_b)/2;        % just guessing at this point, but it seems to work 
end 
if option == 2; midlat = (lat1+lat2)./2; end  % this incorrectly uses the average latitude 
if option == 3; midlat = lat1; end            % this incorrectly uses the initial latitude 
dlon = sin(cr).*(dist/60)./cos(deg2rad(midlat));                                                                
lon2 = lon1 + dlon; 
if option == 4 
  lon2 = lon1 + dlat;                         % this is the naive plane chart where dlat == dlon 
end 
