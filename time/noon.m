function LAN = noon(dnum,long,method) 
% NOON - Local Apparent Noon 
% 
% This procedure determines the time of local apparent noon_ for a given 
% longitude. LAN is the time when the sun is at its greatest zenith angle 
% of the day and when the solar azimuth is directly south or north. 
%  
% Use As:   noon(dnum,long,method) 
% 
% Input:    dnum   = matlab date number (serial days since Jan 01, 1900) 
%           long   = longitude decimal degrees (-W +E) 
%           method = 0 -> use moderate precision almanac 
%                    1 -> use low precision sunang2_  
% Output:   GMT time of local apparent noon_ in decimal hours  

% Example:  noon(datenum(1996,5,18), -121.8,0)               -> 20.0605  hours    GMT 
%       or  deg2dms_(noon(datenum(1996,5,18), -121.8,0),1)   -> 20:03:38 HH:MM:SS GMT  
%       or  deg2dms_(noon(datenum(1996,5,18),-121.8,1)-8,1) -> 12:03:22 HH:MM:SS PST 
%           using low precision algorithm  
%       or  deg2dms_(noon(datenum(1996,5,18),-121.8,1)-8,1) -> 12:03:22 HH:MM:SS PST 
% See Also: SUNANG2, ALMANAC_, SUNRISE_, SUNSET_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 19 May 96; W. Broenkow  taken from NEWSUN.FOR which may contain an error 
%  6 Dec 96; W. Broenkow added higher precision almanac_ routine 
% 02 Dec 1999; B. Schlining changed input to matlab datenumbers

if nargin < 3 
  method = 0; 
end 

[year month day] = datevec(dnum);
long = long*-1;                     % Inputs to the oceans toolboxes use long +W -E
 
hour1 = 12 + long/15;               % approximate time of LAN 
if method == 1  
  jday = julday_(year,month,day);    % julian day of year 1..365
  [zenith,azimuth,declin,eqntime] = sunang2_(jday,hour1,36.8,long); 
  LAN = hour1 + eqntime/15;         % correct LAN by using equation of time 
else 
  [declin,GHA] = almanac_(year,month,day,hour1); 
  if GHA > 180 
    LAN = hour1 - (GHA-360)/15 + long/15; 
  else 
    LAN = hour1 - GHA/15 + long/15; 
  end 
end 
