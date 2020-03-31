function [sset,azimuth] = sunset(sdn,lat,long,method) 
% SUNSET - Determine GMT hour and azimuth of sunset_ from given 
%          date and position 
% 
% Use As:   [sset,azm] = sunset(y,mo,d,lat,long) 
% 
% Input:    sdn   = time in matlab's serial date format (see DATENUM)
%           lat   = latitude  (decimal degrees +N -S) 
%           long  = longitude (decimal degrees -W +E) 
%           method= 0 use almanac.m; 1 = use sunang2_.m 
% 
% Output:   sset  = GMT time of sunset (hours) 
%           azm   = azimuth of setting sun (deg true) 
% 
% Example:  [s,a] = sunset(datenum(1996,5,19),36,-122) 
%              s  = 27.1537 hours GMT   
%                   20.1537 hours (GMT+7) 8:09:14 PM local 
%              a  = 244.6   azimuth (degrees true) 
% 
% See Also: RISESET_, NOON_, SUNANG2_, SUNRISE_, ALMANAC_, EPHEMS_ 

% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 19 May 96; W. Broenkow Adapted from NEWSUN.FOR by R. Reaves 
%  3 Nov 96; W. Broenkow allow use of either sunang2_ or almanac

%  4 Dec 96; W. Broenkow debugged changed tol and sign error in almanac_ method 
% 24 Jul 97; S. Flora debugged line 80 srise to sset. Thank you, Stephanie 

if nargin == 3;  
   method = 0; 
end 
if method > 0 
   method = 1; 
else 
   method = 0; 
end 

uplimb = (34 + 16)/60;              % 34' SD + Std Refraction 16'  
lan = noon(sdn, long); % GMT decimal hours 
tol = 1/60; 
iter = 0; 
jday = date2jul(sdn); 
hour = rem(lan-12,24);          % midnight GMT 

long = long * -1;

while(1)                           % break out of endless loop by iter>10  
   % Using the low precision ephemeris: 
   if method == 1 
      [zenith,azimuth,declin,eqntim] = sunang2_(jday,hour,lat,long); 
      refalt = 90 - zenith + uplimb;   % refracted altitude 
   end 
   
   % Using the higher precision ephemeris: 
   if method == 0; 
      [year month day HH minute second] = datevec(sdn);
      [declin, gha]      = almanac_(year,month,day,hour); 
      [altitude,azimuth] = altazm_(declin,gha,lat,long); 
      refalt             = altitude + uplimb; 
   end 
   
   if (iter == 0) 
      if (refalt > tol) 
         sset    = NaN;               % positive altitude means midnight sun 
         azimuth = NaN; 
         return                       % thus no sunrise_ or sunset 
      else 
         delhrs = 6 + 180.*atan(sin(pi.*declin./180).*tan(pi.*lat./180))./(pi*15); 
         hour   = lan + delhrs;      % minus for sunrise_, plus for sunset 
      end 
   else 
      if (abs(refalt) < tol) 
         sset = hour; 
         return 
      else 
         refalt = - refalt; 
         hour = hour - 180*atan(tan(pi*refalt/180)/cos(pi*lat/180))/(pi*15); 
      end 
   end 
   iter = iter + 1; 
   if (iter > 15) 
      sset    = NaN; 
      azimuth = NaN; 
      return 
   end 
end      

