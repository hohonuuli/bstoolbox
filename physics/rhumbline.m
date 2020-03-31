function [dist,course] = rhumbline(lat1,lon1,lat2,lon2,unit) 
% RHUMBLINE -  Rhumbline distance and course from latitude longitude pairs 
% 
% A rhumbline appears as a straight line on a Mercator chart, but it is 
% not necessarily the shortest distance between two points on a sphere.   
% 
% Use As:   [dist,course] = rhumbline(lat1,lon1,lat2,lon2) 
% 
% Input:    lat1   = starting latitude      (degrees) 
%           lat2   = destination latitude   (degrees) 
%           lon1   = starting longitude     (degrees) 
%           lon2   = destination longitude  (degrees) 
%           unit   = optional distance unit 
%            (default=>111 km/deg; 60 n.miles/deg; 69.0 s.miles/deg) 
% Output:   dist   = distance between lat-long pairs (default = km)
%           course = start to destination   (degrees true) 
% 
% Example:  [dist,course] = rhumbline(36.5,121.75,37.0,122) 
%                    dist = 32.3; course = 338.2 
% 
% See Also: GCIRCLE_, MERIDN1_, MERIDN2_, MRCTMAP_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 25 May 95; adapted from PLOT39 
% 26 Mar 96; WWB vectorized; this grew from a simple 12 line HPL program  
%  3 Aug 96; WWB changed to use meridn2_ for spherical meridional parts 
% 26 Jun 98; Brian Schlining; modified to output vectors as row or
%   columns depending on input vectors

if nargin < 5 
  unit = 111;     % 60 produces nautical miles; use 111 for kilometers 
end 
if nargin < 4 
  error('USE AS: rhumbline(lat1, lon1, lat2, lon2)') 
end 
 
% meridional parts are nautical miles per degree longitude at the given latitude 
merid1 = meridn2_(lat1);        % meridn2_ uses spherical meridional parts 
merid2 = meridn2_(lat2); 
 
% these distances are too close for algorithm to work
% Have to specify [r c] indices until course and dist are 
% initalized. Otherwise the outputs will be column vectors.
dist1 = sqrt((lat2-lat1).^2 + (lon2-lon1).^2); 
[i1r i1c] = find(dist1 < 0.00001); 
if any(i1r | i1c)
   dist(i1r,i1c)   = 0; 
   course(i1r,i1c) = 0; 
end 
 
[i2r i2c] = find(lat1 == lat2);            % here use following algorithm 
if any(i2r | i2c) 
   dist(i2r,i2c) = unit*abs(cos(pi.*lat1(i2r,i2c)./180).*...
      (lon2(i2r,i2c)-lon1(i2r,i2c))); 
   course(i2r,i2c) = 90; 
end 
 
[i3r i3c] = find(lon2(i2r,i2c) > lon1(i2r,i2c)); 
if any(i3r | i3c) 
   % tricky indirect indirect addressing
   course(i2r(i3r),i2c(i3c)) = 270;  
end 
 
i4 = (dist1 >= 0.00001); 
i5 = (lat1 ~= lat2);
[i6r i6c] = find(i4 & i5); 
if any(i6r | i6c) 
   course(i6r, i6c) = (180/pi).*atan(60.*(lon2(i6r,i6c) - ...
      lon1(i6r,i6c))./(merid2(i6r,i6c) - merid1(i6r,i6c))); 
   dist(i6r,i6c) = unit.*abs(lat2(i6r,i6c) - ...
      lat1(i6r,i6c))./cos(pi*course(i6r,i6c)/180); 
end 
if any(i4) 
  [i7r i7c] = find(abs(course(i4)) < 1); 
  if any(i7r | i7c) 
     dist(i7r,i7c) = unit.*abs(lat2(i7r,i7c) - lat1(i7r,i7c)); 
  end 
end 
 
% Correct course for quadrant 
% 1st quadrant 
i8 = find((lat2-lat1 > 0) & (lon2-lon1 < 0)); 
if any(i8) 
  course(i8) = -course(i8); 
end 
 
% 2nd and 3rd quadrants 
i9 = find(lat2-lat1 <= 0); 
if any(i9) 
  course(i9) = 180 - course(i9); 
end 
 
% 4th quadrant 
i10 = find((lat2-lat1 > 0) & (lon2-lon1 > 0)); 
if any(i10) 
  course(i10) = 360 - course(i10); 
end 
 
% east - west 
i11 = find((lat2 == lat1) & (lon2-lon1 > 0)); 
if any(i11) 
  course(i11) = 360 + course(i11); 
end 
