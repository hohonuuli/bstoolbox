function d = dy2date(y)
% DY2DATE   - Decimal year to serial date number
%
% Use as: SerialDateNumber = dy2date(DecimalYear)
% Inputs: DecimalYear = The date in years 
%         (ex. 1998.345 = 
% Output: SerialDateNumber = Matlab method of storing dates
%
% See Also: DATENUM, DATESTR, DATEVEC
% Requires: JUL2DATE

% Brian Schlining
% 22 Dec 1998
% 07 Jan 1998; changed p8 = max(find(p1 > days)) to p8 = max(find(p1 >= days)); This 
% was done because certain whole numbers (ex. 99) would return empty to p8


Year      = floor(y);

% The decimal day (d) needs to rounded to the nearest day (Bob's program isn't perfect)
leapYear  = ~rem(Year,4);        % Find the leap years
Leap      = find(leapYear == 1);
notLeap   = find(leapYear == 0); % The other years are not leap years
JulianDay = ones(size(y))*NaN;

if ~isempty(Leap)
   JulianDay(Leap)    = ((y(Leap) - Year(Leap))*366) + 1;
end
if ~isempty(notLeap)
   JulianDay(notLeap) = ((y(notLeap) - Year(notLeap))*365) + 1;
end

d         = jul2date(JulianDay, Year);   % Convert to a serial date number

