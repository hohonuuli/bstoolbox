function offset = gmtoffset(Lon)
% GMTOFFSET - Calculates the time offset from GMT given the longitude
%
% Use as: offset gmtoffset(Lon)
% Inputs: Lon = Longitude (degrees) in the -W +E convention or 
%          the 0 to 360 (+Eastward) convention
% Output: offset = time offset from GMT in Days
%
% Note: This is a simple algorythmn and does not take into account any arbitrary
%       Geographical boundaries

% Brian Schlining
% 13 May 1999

%==============================================
%Add some very simple Longitude value checking
%==============================================
% Convert Longitudes > 180 to the -W +E convention
if Lon > 180
   Lon = Lon - 360;
end

% Convert Longitudes < -180 to the -W +E convention
if Lon < -180
   Lon = 360 + Lon;
end

%======================
% Calculate the offset
%======================
if Lon < 0 
   offset = floor((Lon + 7.5)/180*12)/24; 
else
   offset = ceil((Lon - 7.5)/180*12)/24;
end

