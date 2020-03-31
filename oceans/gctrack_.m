function [lat,lon] = gctrack_(lat1,lon1,lat2,lon2,dist,units) 
% GCTRACK_ - Return two vectors containing latitude longitude pairs 
%            between two positions on earth. 
% 
% Use As:   [lat,lon] = gctrack_(lat1,lon1,lat2,lon2,dist,units) 
% 
% Input:    lat1  = Initial latitude      (deg; +N/-S) 
%           lon1  = Initial longitude     (deg; +W/-E or -W/+E)
%           lat2  = Destination latitude  (deg; +N/-S) 
%           lon2  = Destination longitude (deg; +W/-E or -W/+E) 
%           dist  = distance between interpolated positions  
%                   (min arc or n.miles)  
%           units = 0 = decimal degrees; longitudes are +W/-E 
%                   1 = DD.MMm;              "       "    " 
%                   2 = decimal degrees; longitudes are -W/+E 
%                   3 = DD.MMm;              "       "    " 
% 
% Output:   lat   = latitude (decimal degrees) of interpolated positions 
%           lon   = longitude (decimal degrees) of interpolated positions 
%                   The number of lat/long pairs is the great circle 
%                   distance between lat1/lon1 and lat2/lon2 divided 
%                   by dist. 
% 
% Example:  Moss Landing to Honolulu using DD.MM -W longitude 
%           [a,b] = gctrack_(36.48,-121.48,21.16,-157.52,500,3) 
%              a  =   36.8000   34.0559   30.6077   26.5902   22.1262   17.3550   21.2667 
%              b  = -121.8000 -131.4588 -140.4408 -148.7586 -156.4884 -163.7520 -157.8667 
% 
% Note:     The output positions are in decimal degrees only, because 
%           they will usually be used to plot a track line. It is not 
%           useful to plot DD.MMm values. 
% 
% See Also: GCINTRP_, GCIRCLE 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 22 May 96; W.Broenkow 
% 20 Jun 96; wwb fixed dms2deg_  
% Uses GCIRCLE_ GCINTERP_ DMS2DEG_ 
 
if nargin < 6 
  units = 0 
end 
D = gcircle_(lat1,lon1,lat2,lon2,units); 
N = floor(D/dist) + 1; 
if N > 600; 
  disp('GCTRACK  Exception: Too many intervals between positions') 
  disp('         Reduce number of intervals to 600') 
  break 
end 
 
lat = NaN*ones(N,1); 
lon = NaN*ones(N,1); 
 
lat(1) = lat1;  % save initial position 
lon(1) = lon1; 
i = 2; 
while D > dist 
 [lat(i),lon(i)]  = gcintrp_(lat1,lon1,lat2,lon2,dist,units); 
 D = gcircle_(lat1,lon1,lat2,lon2,units); 
 lat1 = lat(i); 
 lon1 = lon(i); 
 i = i + 1; 
 % fprintf('%3i Lat%7.3f Lon%7.3f Dist%7.1f \n',i,lat1,lon1,D);
 
end 
lat(i) = lat2;  % save destination 
lon(i) = lon2; 
if units == 1 | units == 3 
  lat = dms2deg_(lat); 
  lon = dms2deg_(lon); 
end  
