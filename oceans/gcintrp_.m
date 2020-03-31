function [interp_lat,interp_lon] = gcintrp_(lat1,lon1,lat2,lon2,dist,units) 
% GCINTRP_ - Great circle interpolator: Returns latitude and longitude of  
%            the distance from the starting position 
% 
% Use As:  [interp_lat,interp_lon] = gcintrp_(lat1,lon1,lat2,lon2,dist,units) 
% 
% Input:   lat1  = Initial Latitude      (DD.ddd or DD.MMm) +N/-S 
%          lon1  = Initial Longitude     (DD.ddd or DD.MMm) +W/-E OR -W/+E 
%          lat2  = Destination Latitude  (DD.ddd or DD.MMm) +N/-S 
%          lon2  = Destination Longitude (DD.ddd or DD.MMm) +W/-E OR -W/+E 
%          dist  = Great Circle Distance (Minutes of Arc) from lat1 & lon1 
%          units = 0 = decimal degrees; longitudes are +W/-E  {default} 
%                  1 = DD.MMm;              "       "    "     
%                  2 = decimal degrees; longitudes are -W/+E 
%                  3 = DD.MMm;              "       "    " 
% 
% Output:  interp_lat = Interpolated Latitude   consistent with units 
%          interp_lon = Interpolated Longitude      "        "    " 
% 
% Example: Moss Landing towards Honolulu using DD.MM -W longitude 
%          [a,b] = gcintrp_(36.48,-121.48,21.16,-157.52,100,3) 
%              a = 36.1853; b = -123.4706 
% 
% See Also: GCIRCLE_, GCTRACK 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 14 Apr 89; R. Reaves as part of the VAX FORTRAN ephemeris routines 
%  6 May 96; W. Broenkow translated from VAX FORTRAN EPHEM.FOR 
%               Variable names are identical to the VAX program. 
% 20 Jun 96; wwb deg2dms dms2deg_ changes 
% Uses: GCIRCLE_ DEG2DMS_ DMS2DEG_ 
% MUST VECTORIZE 
 
if nargin < 6; 
  units = 0; 
elseif nargin < 5 
  disp('GCINTERP Requires 5 inputs:') 
  disp('         lat1,lon1,lat2,lon2,dist') 
end 
p180 = pi/180; 
 
if units == 1 | units == 3 
  LA1 = dms2deg_(lat1, 0);        % Convert DD.MMm to DD.ddd 
  LO1 = dms2deg_(lon1,0); 
  LA2 = dms2deg_(lat2, 0); 
  LO2 = dms2deg_(lon2,0); 
else 
  LA1 = lat1; 
  LO1 = lon1; 
  LA2 = lat2; 
  LO2 = lon2; 
end 
 
if units == 2 | units == 3      
  LO1 = -LO1;                  % Convert West Longitude to +   
  LO2 = -LO2;                  % and     East Longitude to - 
end 
 
D = dist/60;               % Convert minutes or naut miles to degrees 
if dist == 0 
  LA3 = LA1; 
  LO3 = LO1; 
elseif abs(LA1) == 90          % North or South Pole 
  LA3 = LA1 - D; 
  LO3 = LO2; 
elseif abs(LA2) == 90          % North or South Pole 
  LA3 = LA1 - D; 
  LO3 = LO1; 
else 
  [gcdist,head] = gcircle_(LA1,LO1,LA2,LO2,0); % units are now DD.ddd +W 
  if (dist == gcdist); 
    LA3 = LA2; 
    LO3 = LO2; 
  else 
    if (dist < 0) 
      head = -head; 
    end 
    if (head < 0) 
      head = head + 360; 
    end  
    LA3 = (180/pi)*asin(sin(p180*LA1)*cos(p180*D)+cos(p180*LA1)*sin(p180*D)*cos(p180*head)); 
    if (abs(LA3) ~= 90) 
      LO3 = (cos(p180*D)-sin(p180*LA1)*sin(p180*LA3))/(cos(p180*LA1)*cos(p180*LA3)); 
      if (LO3 >= 1) 
        LO3 = 0.0; 
      elseif (LO3 <= -1) 
        LO3 = 180; 
      else 
        LO3 = (180/pi)*acos(LO3); 
      end 
      if (head < 180) 
        LO3 = -LO3; 
      end 
      LO3 = LO1 + LO3; 
    else 
      LO3 = 0.0; 
    end 
  end 
end 
 
% Correct latitude (-90 to 90) and longitude (-180 to 180) 
LA3 = rem(LA3 + (180+360),360) - 180; 
if (abs(LA3) > 90) 
  LA3 = sign(180,LA3) - LA3; 
  LO3 = LO3 + 180;             % Longitude is on other side of globe 
end 
LO3 = rem(LO3 + (180+360),360) - 180; 
 
% Convert to proper units and sign 
if units == 2 | units == 3      % Convert output longitude to -W 
  LO3 = -LO3; 
end 
if units == 1 | units == 3      % Convert DD.ddd to DD.MMm 
  interp_lat = deg2dms_(LA3,1); 
  interp_lon = deg2dms_(LO3,1); 
else 
  interp_lat = LA3; 
  interp_lon = LO3; 
end  
