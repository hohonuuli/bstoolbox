function [dist,head] = gcircle_(lat1,lon1,lat2,lon2,units) 
% GCIRCLE_ - Great circle distance and heading from two positions 
% 
% Use As:   [dist,head] = gcir(lat1,lon1,lat2,lon2,units) 
% 
% Input:    lat1  = Initial latitude      (DD.ddd or DD.MMm) +N/-S 
%           lon1  = Initial longitude     (DD.ddd or DD.MMm) +W/-E or -W/+E 
%           lat2  = Destination latitude  (DD.ddd or DD.MMm) +N/-S 
%           lon2  = Destination longitude (DD.ddd or DD.MMm) +W/-E or -W/+E 
%           units = 0 = decimal degrees; longitudes are +W/-E  {default} 
%                   1 = DD.MMm;              "       "    "   
%                   2 = decimal degrees; longitudes are -W/+E 
%                   3 = DD.MMm;             "       "    "   
% 
% Output:   dist  = Great circle distance (naut miles = minutes arc) 
%           head  = Great circle heading  (deg true) 
% 
% Example:  [d h] = gcircle_(36.8,121.8,21.2,157.9,0)        Note: DD.ddd +W 
%               d = 2096.0; h = 253.6 
%           [d h] = gcircle_(36.48,-121.48,21.16,-157.52,3)  Note: DD.MMm -W  
%               d = 2092.2; h = 253.7 
% 
% See Also: GCINTRP_, GCTRACK_, RHUMBL_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 19 Apr 1995; R. Reaves 
% 29 Jan 1995; W. Broenkow vectorized, revised output distance to N. Miles 
% 23 May 1996; W. Broenkow added units 
% 20 Jun 96; wwb changed dms2deg 
 
if (nargin < 5) 
  units = 0; 
end 
 
if units == 1 | units == 3 
  la1 = dms2deg_(lat1,0); % unit = 0 in todeg converts DD.MMm to DD.ddd 
  lo1 = dms2deg_(lon1,0); 
  la2 = dms2deg_(lat2,0); 
  lo2 = dms2deg_(lon2,0); 
else 
  la1 = lat1; 
  lo1 = lon1; 
  la2 = lat2; 
  lo2 = lon2; 
end 
 
if units == 2 | units == 3 
  lo1 = -lo1; 
  lo2 = -lo2; 
end 
 
if (abs(la1) == 90), 
  dist = la1 - la2; 
  if (la1 > 0), 
    head = lo2 - lo1 + 180; 
  else 
    head = lo1 - lo2 + 180; 
   end; 
else 
  p180 = pi/180; 
  C1 = cos(la1*p180); 
  C2 = cos(la2*p180); 
  S1 = sin(la1*p180); 
  S2 = sin(la2*p180); 
  dlon = (lo1-lo2)*p180; 
  dist = S1.*S2 + C1.*C2.*cos(dlon); 
  if (dist >= 1) 
    dist = 0; 
  else 
    if (dist <= -1) 
      dist = 180; 
    else 
      dist = acos(dist)./p180; 
    end; 
  end; 
    head = 0; 
    if (dist == 0) 
      return; 
    end; 
    Y = sin(dlon).*C2; 
    if (Y==0) 
      if (lat1 > lat2) 
        head = 180; 
       end; 
    else 
       head = atan2(Y,C1.*S2 - S1.*C2.*cos(dlon))./p180; 
    end; 
end; 
if (dist<0), 
  dist = -dist; 
  head = head - 180; 
end; 
if (head<0),  
  head = head + 360; 
end; 
dist = dist*60;    % output in n. miles or minutes of arc 
 
