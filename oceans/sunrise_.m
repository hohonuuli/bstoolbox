function [srise,azimuth] = sunrise_(year,month,day,lat,long,method) 
% SUNRISE_ - Determine time of sunrise_ from given date and position. 
% 
% Use As:   srise = sunrise_(y,mo,d,lat,long,method) 
% 
% Input:    y       = year as 1996 
%           mo      = month 1..12 
%           d       = day 1..31 
%           lat     = latitude  (decimal degrees +N -S) 
%           long    = longitude (decimal degrees +W -E) 
%           method  = 0 = use almanac_(); 1 = use sunang2 
% Output:   srise   = GMT time of sunrise_ (GMT hours) 
%           azimuth = azimuth of rising sun (degrees true) 
% 
% Example:  [s,a] = sunrise_(1996,5,19,36,122) 
%               s = 12.9853 hours GMT 
%                    5.9853 hours (GMT-7) 5:59:07 AM local 
%               a = 115.4   azimuth (degrees true) 
% 
% See Also: RISESET_, NOON_, SUNANG2_, SUNSET_, ALMANAC_, EPHEMS_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 19 May 96; W. Broenkow Adapted from NEWSUN.FOR by R. Reaves 
%  3 Nov 96; W. Broenkow allow use of either sunang2_ or almanac
 
%  4 Dec 96; W. Broenkow and M. Feinholz debugged almanac_ version 
 
if nargin == 5;  
  method = 0; 
elseif method > 0 
  method = 1; 
else 
  method = 0; 
end 
 
uplimb = (34 + 16)/60;              % 34' SD + Std Refraction 16'  
   lan = noon_(year,month,day,long); % GMT decimal hours 
   tol = 1/60; 
  iter = 0; 
  jday = julday_(year,month,day); 
  hour = rem(lan-12,24);           % midnight GMT 
 
while(1)                           % break out of endless loop by iter>10  
  % Using the low precision ephemeris: 
  if method == 1 
    [zenith,azimuth,declin,eqntim] = sunang2_(jday,hour,lat,long); 
    refalt = 90 - zenith + uplimb;   % refracted altitude 
  end 
 
% Using the higher precision ephemeris: 
  if method == 0; 
       [declin, gha] = almanac_(year,month,day,hour); 
  [altitude,azimuth] = altazm_(declin,gha,lat,long); 
              refalt = altitude + uplimb; 
  end 
  if (iter == 0) 
    if (refalt > tol) 
      srise = NaN;                 % positive altitude means midnight sun 
      azimuth = NaN; 
      return                       % thus no sunrise_ or sunset 
    else 
      delhrs = 6 + 180.*atan(sin(pi.*declin./180).*tan(pi.*lat./180))./(pi*15); 
      hour   = lan - delhrs;      % minus for sunrise_, plus for sunset 
    end                              
  else 
    if (abs(refalt) < tol) 
      srise = hour; 
      return 
    else 
      hour = hour - 180*atan(tan(pi*refalt/180)/cos(pi*lat/180))/(pi*15); 
    end 
  end 
  iter = iter + 1; 
  if (iter > 15) 
    srise = NaN; 
    azimuth = NaN; 
    return 
  end 
end 
