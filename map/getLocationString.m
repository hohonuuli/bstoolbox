function locS = getLocationString(lat, lon)
% getLocationString - return a formated string of latitude and longitude
%
% Use as: locS = getLocationString(lat, lon)
%
% Inputs: lat = Latitude in decimal degrees (+E/-W)
%         lon = Longitude in decimal degrees (+N/-S)
%

% Brian Schlining
% 10 Nov 2000

if nargin < 3
   flag = 0;
end

[rLat cLat] = size(lat);
lLat = length(lat);
[rLon cLon] = size(lon);
lLon = length(lon);

if lLat ~= 1 & lLon == 1
   lon = ones(size(lat))*lon;
   [rLon cLon] = size(lon);
end

if lLon ~= 1 & lLat == 1
   lat = ones(size(lon))*lat;
   [rLat cLat] = size(lat);
end

latS2 = setstr(ones(size(lat))*78); % 'N'
i = find(lat < 0);
latS2(i) = 83; 							% 'S';
lonS2 = setstr(ones(size(lon))*69); % 'E'
i = find(lon < 0);
lonS2(i) = 87; 							% 'W';

for r = 1:rLat
   for c = 1:cLat
      locS{r,c} = [num2str(abs(lat(r,c))) latS2(r,c) ' ' num2str(abs(lon(r,c))) lonS2(r,c)];
   end
end




