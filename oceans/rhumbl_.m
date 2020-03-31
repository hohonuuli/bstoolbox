function [dist,course] = rhumbl_(lat1,lon1,lat2,lon2,unit) 
% RHUMBL_ -  Rhumbline distance and course from latitude longitude pairs 
% 
% A rhumbline appears as a straight line on a Mercator chart, but it is 
% not necessarily the shortest distance between two points on a sphere.   
% 
% Use As:   [dist,course] = rhumbl_(lat1,lon1,lat2,lon2) 
% 
% Input:    lat1   = starting latitude      (degrees) 
%           lat2   = destination latitude   (degrees) 
%           lon1   = starting longitude     (degrees) 
%           lon2   = destination longitude  (degrees) 
%           unit   = optional distance unit (default 60 n.miles/deg; 
%                                      111 km/deg; 69.0 s.miles/deg) 
% Output:   dist   = distance between lat-long pairs (n. miles)
%           course = start to destination   (degrees true) 
% 
% Example:  [dist,course] = rhumbl_(36.5,121.75,37.0,122) 
%                    dist = 32.3; course = 338.2 
% 
% See Also: GCIRCLE_, MERIDN1_, MERIDN2_, MRCTMAP_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 25 May 95; adapted from PLOT39 
% 26 Mar 96; WWB vectorized; this grew from a simple 12 line HPL program  
%  3 Aug 96; WWB changed to use meridn2_ for spherical meridional parts 
 
if nargin < 5 
  unit = 60;     % this produces nautical miles; use 111 for kilometers 
end 
if nargin < 4 
  disp('RHUMBL_ function requires lat1 lon1 lat2 lon2') 
  return 
end 
 
% meridional parts are nautical miles per degree longitude at the given latitude 
merid1 = meridn2_(lat1);        % meridn2_ uses spherical meridional parts 
merid2 = meridn2_(lat2); 
 
% these distances are too close for algorithm to work 
dist1 = sqrt((lat2-lat1).^2 + (lon2-lon1).^2); 
i1 = find(dist1 < 0.00001); 
if any(i1) 
  dist(i1) = zeros(size(i1)); 
course(i1) = zeros(size(i1)) 
end 
 
i2 = find(lat1 == lat2);                % here use following algorithm 
if any(i2) 
  dist(i2) = unit*abs(cos(pi.*lat1(i2)./180).*(lon2(i2)-lon1(i2))); 
course(i2) = 90*ones(size(i2)); 
end 
 
i3 = find(lon2(i2) > lon1(i2)); 
if any(i3) 
  course(i2(i3)) = 270*ones(size(i2(i3))); % tricky indirect indirect addressing 
end 
 
i4 = (dist1 >= 0.00001); 
i5 = (lat1 ~= lat2); 
i6 = find(i4 & i5); 
if any(i6) 
  course(i6) = (180/pi).*atan(60.*(lon2(i6) - lon1(i6))./(merid2(i6) - merid1(i6))); 
    dist(i6) = unit.*abs(lat2(i6)-lat1(i6))./cos(pi*course(i6)/180); 
end 
if any(i4) 
  i7 = find(abs(course(i4)) < 1); 
  if any(i7) 
    dist(i7) = unit.*abs(lat2(i7)-lat1(i7)); 
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
