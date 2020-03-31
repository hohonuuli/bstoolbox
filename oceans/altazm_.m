function [altitude,azimuth] = altazm_(decl,gha,lat,long) 
% ALTAZM_ - Celestial altitude and azimuth from declination,  
%           Greenwich Hour Angle, latitude and longitude. 
% 
% Use As:  [azimuth,altitude] = altazm_(decl,gha,lat,long) 
% 
% Input:    decl     = Declination          (degrees) 
%           gha      = Greenwich Hour Angle (degrees) 
%           lat      = Latitude             (decimal degrees +N/-S) 
%           long     = Longitude            (decimal degrees +W/-E) 
% Output:   altitude = Solar altitude       (degrees) 
%           azimuth  = Solar azimuth        (degrees) 
% 
% Example:  [alt,azm] = altazm_(-0.42,118.13,36,121) 
%                       alt = 53.48; azm = 175.17 
% 
% See Also: ALMANAC_, SUNANG2_, EPHEMS_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 22 Jul 1997; W. Broenkow 
 
% Much effort was required to adapt this from sunang2_.m 
% which has a quadrant ambiguity. The algorithm here is 
% taken from Wilson (1980). 
 
Nargs = nargin; 
if Nargs == 0 
  help altazm 
  return 
end 
 
latR  = deg2rad_(lat);                 % latitude    in radians 
lonR  = deg2rad_(long);                % longitude   in radians 
decR  = deg2rad_(decl);                % declination in radians 
GHAR  = deg2rad_(gha);                 % GHA         in radians 
LHAR  = GHAR - lonR;                   % LHA         in radians 
 
% solar zenith angle   theta-0 
zenR  = acos(sin(latR).*sin(decR) + cos(latR).*cos(decR).*cos(LHAR)); 
 
% solar azimuth angle  Phi-0 
% sunang2_.m algorithm 
% azmR  = asin(sin(abs(LHAR)).*cos(decR)./sin(zenR)); 
 
% wilson_ (1980) Algorithm 
azmR  = acos((-sin(latR).*cos(LHAR).*cos(decR) + sin(decR).*cos(latR))./sin(zenR)); 
 
sign1 = sign(-cos(decR).*sin(LHAR)./sin(zenR)); 
sign2 = sign(sin(azmR)); 
indx = find(sign1 ~= sign2); 
 
if exist('indx') 
  azmR(indx) = 2*pi - azmR(indx); 
end 
 
zenith   =  rad2deg_(zenR); 
altitude =  90 - zenith; 
azimuth  =  rad2deg_(azmR); 
 
