function [altitude,azimuth,hour] = daynite_(yr,mon,day,lat,lon,zone) 
% daynite_ - Make a polar plot of the sun altitude vs azimuth 
%            for a given date, latitude and longitude. 
% UNDER DEVELOPMENT... THIS IS NOT FINISHED 
% Use As: [altitude,azimuth,hour] = daynite_(day,mon,yr,lat,lon,zone) 
% Inputs: year   as 1996 
%         mon  = month (1-12) 
%         day  = day of the month (1-31) 
%         lat  = latitude (degrees +N-S) 
%         lon  = longitude (degrees +W-E) 
% Output: Polar plot of altitude vs azimuth 
%         altitude = sun altitude (degrees) 
%         azimuth  = sun azimuth (degrees) 
%         hour     = GMT time (decimal hours) 
%              
% NOTE:   This algorithm is OK for positive altitudes, but 
%         fails for negative altitudes. Must consult Wilson's 
%         paper to determine how to plot sun altitude at night.
 
% See Also:  SUNANG2_, SUNRISE_, NOON_, SUNSET_, RISESET_
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 26 May 96; W. Broenkow 
%  7 Aug 96; WWB using geopolr_
 
if nargin < 5 
  error('Required inputs are: day,month,year,lat,long'); 
elseif nargin < 6 
  zone = round(lon/15); 
end 
juld = julday_(yr,mon,day); 
n = 0;   
for h = 0:.5:24 
  n = n + 1; 
  hour(n) = h+zone;  
  [zenith(n),azimuth(n)] = sunang2_(juld,h+zone,lat,lon); 
  altitude(n) = abs(zenith(n)-90); 
end 
figure(1); 
clf; 
geopolr_(azimuth,zenith); 
figure(2); 
clf; 
polar(2*pi*hour/24,altitude); 
 
