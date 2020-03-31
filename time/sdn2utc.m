function utc = sdn2utc(sdn)
% SDN2UTC   - Convert matlab date format to UTC seconds
%
% Use as: utc = sdn2utc(sdn);
%
% utc = Seconds since 01 Jan 1970 00:00:00
% sdn = Matlab datenumber (se DATENUM and DATESTR)

% Brian Schlining
% 12 Apr 2000

%datenum('01 Jan 1970 00:00:00') = 719529
utc = (sdn - 719529)*60*60*24;