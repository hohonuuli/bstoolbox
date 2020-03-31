function [ZEN,ALT,AZ] = solarzenith(DateTime,LAT,LON)

% SOLARZENITH - Calculate Solar Zenith Angle
%
% Calculated the solar zenith angle for a given day and
% position. ALMANAC_.M is used to compute declination, GHA 
% distance and equation of time. These vaules are then input
% into ALTAZM_.M which calculates celestial altitude and azimuth 
% from declination, Greenwich Hour Angle, latitude and longitude. 
%
% ALMANAC_.M
% Ref:  Van Flanderen and Pulkkinen (1979) Low Precision Formulae for Planetary 
%       Positions. Astrophysical Journal Supplement Series, 41:391-411. 
%
% ALTAZM_.M
% Algorithms taken from Wilson (1980). 
%
% Use As: ZEN = solarzen_(DateTime,LAT,LONG)
% Inputs: DateTime = GMT Date and Time in matlab's date format(see DATENUM)
%         LAT      = Latitude (DD.MMmm) where N+ and S-
%         LON      = Longitude (DD.MMmm) where W- and E+
% Output: ZEN      = Solar Zenith angle (degrees)
%         ALT      = Solar altitude     (degrees)
%         AZ       = Solar azimuth      (degrees)

% 20 Dec 99; S. Flora - created from nderive_
% 15 Mar 2000; B. Schlining - Modified inputs

ZEN = [];

if nargin == 0
  help solarzenith
  return
end

if nargin < 3
  disp('  SOLARZEN_ Error (3 Inputs Required)')
  return
end

LON = -LON;

[Year, Month, Day, Hour, Minute, Second] = datevec(DateTime);

%[Year,Month,Day,Hour,Minute,Second,DOY,GMT] = timeupk_(DateTime);        % Normalize average for station
%if Year >= 0 & Year <= 60                                                % Fix up the Year 
%  Year = Year + 2000;
%else
%  Year = Year + 1900;
%end

Hour = Hour + (Minute + Second/60)/60;

% ALMANAC_ and ALTAZM_ replaces SUNANG2_
[DECL,GHA,DIST,EQ_TIME] = almanac_(Year,Month,Day,Hour);
%avg_latd = dms2deg_(LAT,0);                                    % Average and Convert to DD.dd
%avg_lond = dms2deg_(LON,0);                                    % Average and Convert to DD.dd
[ALT,AZ] = altazm_(DECL,GHA,LAT,LON);                % Calculate azimuth and altitude
ZEN = (90 - ALT);                                              % Zenith angle in degrees

