function [degrees, minutes, seconds] = dd2dms(decimalDegrees)

% Convert Decimal Degrees to dms

% Brian Schlining
% 17 Dec 2002

if (decimalDegrees >= 0)
    degrees = floor(decimalDegrees);
else
    degrees = ceil(decimalDegrees);
end
decimalMinutes = abs(decimalDegrees - degrees) * 60;
minutes = floor(decimalMinutes);
seconds = (decimalMinutes - minutes) * 60;