function [utmEasting, utmNorthing, zoneNumber] = geo2utm(longitude, latitude, zoneNumber)
% GEO2UTM   - Convert geographic cooridinates (WSGS 1984) to utm
%
% Use As: [utmEasting, utmNorthings, zoneNumber] = geo2utm(longitude, latitude, zoneNumber)
%         [utmEasting, utmNorthings] = geo2utm(longitude, latitude, zoneNumber)
%         [utmEasting, utmNorthings, zoneNumber] = geo2utm(longitude, latitude)
%
% Inputs: longitude = longidute in decimal degrees
%         latitude  = latitude in decimal degrees
%         zoneNumbe = Zone to force utm cooridinates to (optional)
%
% Output: utmEasting = east cooridinate in utm meters
%         utmNorthing = north cooridinate in utm meters
%         zoneNumber = UTM zone of a position

% Brian Schlining
% 27 Jun 2002
% 27 Jun 2002 - B. Schlining - verified results against org.mbari.gis.util.GisUtil.geoToUtm()
%   Perfect match. the GisUtil.geoToUtm had been verified against other sources. So the results
%   of this mathod should be considered accurate for WSGS84 spheroid



a = 6378137.0; % WGS84 ellipsoid radius
eccSquared = 0.00669438; % WGS84 eccsq
k0 = 0.9996;

%longOrigin;
%eccPrimeSquared;
%N, T, C, A, M;

%Make sure the longitude is between -180.00 .. 179.9
longTemp = (longitude + 180) - (floor((longitude + 180)./360)) .* 360 - 180; % -180.00 .. 179.9;

latRad  = latitude .* pi ./ 180;
longRad = longitude .* pi ./180;

% Java code for determinig the zone. We don't use that here. Instead we suppy the zone number
% to force a zone
%longOriginRad;

if nargin < 3
    
    % Figure out the standard zone number
    zoneNumber = floor((longTemp + 180) ./ 6) + 1;
    
    ii = find( latitude >= 56 & latitude < 64 & longTemp >= 3 & longTemp < 12 );
    if (~isempty(ii))
        zoneNumber(ii) = 32;
    end
    
    % Special zones for Svalbard
    ii = find( latitude >= 72 & latitude < 84 );
    if (~isempty(ii))
        jj = find(longTemp(ii) >= 0  & longTemp(ii) <  9);
        if (~isempty(jj))
            zoneNumber(ii(jj)) = 31;
        end
        jj = find(longTemp(ii) >= 9  & longTemp(ii) <  21);
        if (~isempty(jj))
            zoneNumber(ii(jj)) = 33;
        end
        jj = find(longTemp(ii) >= 21  & longTemp(ii) <  33);
        if (~isempty(jj))
            zoneNumber(ii(jj)) = 35;
        end
        jj = find(longTemp(ii) >= 33  & longTemp(ii) <  42);
        if (~isempty(jj))
            zoneNumber(ii(jj)) = 37;
        end
    end
end

longOrigin = (zoneNumber - 1) .* 6 - 180 + 3;  % +3 puts origin in middle of zone
longOriginRad = longOrigin .* pi ./ 180;

eccPrimeSquared = (eccSquared) ./ (1-eccSquared);

N = a ./ sqrt(1 - eccSquared .* sin(latRad) .* sin(latRad));
T = tan(latRad) .* tan(latRad);
C = eccPrimeSquared .* cos(latRad) .* cos(latRad);
A = cos(latRad) .* (longRad - longOriginRad);

M = a .* ((1 - eccSquared ./ 4 - 3 .* eccSquared .* eccSquared ./ 64 - 5 .* ...
    eccSquared .* eccSquared .* eccSquared ./ 256) .* latRad - ...
(3 .* eccSquared ./ 8 + 3 .* eccSquared .* eccSquared ./ 32 + ...
    45 .* eccSquared .* eccSquared .* eccSquared ./ 1024) .* sin(2 .* latRad) + ...
    (15 .* eccSquared .* eccSquared ./ 256 + ...
    45 .* eccSquared .* eccSquared .* eccSquared ./ 1024) .* sin(4 .* latRad) - ...
    (35 .* eccSquared .* eccSquared .* eccSquared ./ 3072) .* sin(6 .* latRad));

utmEasting = (k0 .* N .* (A + (1 - T + C) .* A .* A .* A ./ 6.0 + ...
    (5 - 18 .* T + T .* T + 72 .* C -58 .* eccPrimeSquared) .* ...
    A .* A .* A .* A .* A ./ 120.0) + 500000.0);

utmNorthing = (k0 .* (M + N .* tan(latRad) .* ...
    (A .* A ./ 2 + (5 - T + 9 .* C + 4 .* C .* C) .* A .* A .* A .* A ./ 24.0 ...
    + (61 - 58 .* T + T .* T + 600 .* C - 330 .* eccPrimeSquared) .* ...
    A .* A .* A .* A .* A .* A ./ 720.0)));

if(latitude < 0)
    utmNorthing = utmNorthing + 10000000.0; %10000000 meter offset for southern hemisphere
end

