function S = jul2date(JDay,Year)
% JUL2DATE  - Converts a julian day of the year to date
%
% Use As: S = jul2date(JDay,Year)
%
% Inputs: JDay = Julian day of the year
%         Year = year (ex. 1998)
%
% Output: S = Number representation of the date 
%             (see DATENUM for format)

% % Copyright (c) 1998 Brian Schlining
% 22 Jan 1998
% 22 Apr 1999; Inputs of NaN now return NaN's rather than crash

if length(Year) == 1 & length(JDay) ~= 1
   Year = ones(size(JDay))*Year;
end

[r c]            = size(JDay);
[rY cY]          = size(Year);
if r ~= rY | c ~=cY
   error('Inputs must have the same dimensions')
end

BadYear          = find(isnan(Year));
Year(BadYear)    = 1;
BadDay           = find(isnan(JDay) | JDay < 1);
JDay(BadDay)     = 1;

[Year Month Day] = caldate_(JDay, Year);
S                = datenum(Year, Month, Day);
if ~isempty(BadYear)
   S(BadYear)       = NaN;
end
if ~isempty(BadDay)
   S(BadDay)        = NaN;
end

%===================================================
% CALDATE_
%===================================================
function [Year,Month,Day] = caldate_(JulianDay,Year) 



Month   = ones(size(Year))*NaN;
Day     = ones(size(Year))*NaN;
Hour    = ones(size(Year))*NaN;
Minute  = ones(size(Year))*NaN;
Second  = ones(size(Year))*NaN;

leapYear = ~rem(Year,4);       % Find the leap years
Leap    = find(leapYear == 1);
notLeap = find(leapYear == 0); % The other years are not leap years


if ~isempty(Leap)
   Feb          = 29;
   daysPerMonth = [0 31 Feb 31 30 31 30 31 31 30 31 30 31];
   days         = cumsum(daysPerMonth);
   for n = 1:length(Leap)
      Month(Leap(n))  = max(find(JulianDay(Leap(n)) > days));      % month
      Day(Leap(n))    = JulianDay(Leap(n)) - days(1, Month(Leap(n))); % day of month
   end
   
end

if ~isempty(notLeap)
   Feb            = 28;
   daysPerMonth   = [0 31 Feb 31 30 31 30 31 31 30 31 30 31];
   days           = cumsum(daysPerMonth);
   for n = 1:length(notLeap)
      Month(notLeap(n)) = max(find(JulianDay(notLeap(n)) > days));      % month
      Day(notLeap(n))   = JulianDay(notLeap(n)) - days(1, Month(notLeap(n))); % day of month
   end
   
end


