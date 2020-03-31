function Jday = date2jul(S)
% DATE2JUL  - Converts a date to julian day of the year
%
% Use As: JDay = date2jul(S)
%
% Inputs: S = String or Number representation of the date
%             (see DATESTR for valid types)
%
% Output: Jday = Julian Day of the year


% % Copyright (c) 1999 Brian Schlining
% 21 Jan 1999

[Y,M,D] = datevec(S);
Jday    = julday(Y,M,D);


%==============================================================================================
function [jd,dow] = Julday(y,mo,d,option)
% JULDAY    - Determine the julian day of the year (1..365) or julian date
%
% Use As:   [jday,dow] = julday(y,mo,d,option)
%
% Input:    y  = year         30..99 is used as 1930..
%                             00..29 is used as 2000..
%                             1582 any 4-digit year
%           mo = month        1..12
%           d  = day of month 1..31
%           option = 0 or 1  day of year or Julian Date option
% Output:   jday = days from 0 Jan current year if option = 0 Julian day of year
%      or   jday = days from 4713 BC            if option = 1 Julian Date
%           dow  = day of week 1 = Sunday  2 = Monday .. 7 = Saturday
%
% Example:  julday(79,06,14,0)    -> 165
%           julday(79,06,14,1)    -> 24440385
%           julday(1582,10,15,1)  -> 2299170.5
%           julday(1968,5,23.5,1) -> 2440000.0
%           julday(1582,10,16) - julday(1582,10,15) -> -9 !!
%              This is because the Julian calendar
%              started at noon on 15 October 1582
%              Julian Date 0 is 4712 BC
%
% See Also: CALDATE, DEG2DMS, DMS2DEG, FMTTIME, HELPDATE, JULDATE, JULSEC, NOW

% Copyright (c) 1996 by Moss Landing Marine Laboratories
% Uses function juldate.m
% 15 Apr 95; W. Broenkow
% 29 Jan 96; replaced juldate_.mex by juldate.m
% 25 Mar 96; WWB vectorized added day of week, debugged
% 21 Jun 96; WWB changed help

if ~exist('option'),
option = 0;
end;
if (nargin < 3),
  jd = NaN;
  disp('ERROR:  JULDAY Must input 3 arguments:  day, month, year')
else
  % Parse shorthand years
  yr = y;                              % do all years first
  ifind1 = find(y < 30*ones(size(y)) & y >= zeros(size(y)));   % then correct shorthand years
  if exist('ifind1')
    yr(ifind1) = 2000 + y(ifind1);   % up to 2030
  end
  ifind2 = find(y >= 30*ones(size(y)) & y < 100*ones(size(y)));
  if exist('ifind2')
    yr(ifind2) = 1900 + y(ifind2);           % from 1931..1999
  end
end;
% look for Julian Date option
if (option > 0),
  jd  = juldate(yr,mo,d);
  dow = 1+rem(floor(jd)+2,7);
else
  jd1  = juldate(yr,ones(size(yr)),zeros(size(yr)));  % julian date for first of given year
  jd2  = juldate(yr,mo,d);                            % julian date
  jd   = jd2 - jd1;              % number of days from Jan 0 = day of year
  dow  = 1+ rem(floor(jd2+2),7); % day of the week 1=Sunday
end

function yyy = juldate(YEAR,MONTH,DAY)
% JULDATE   - Converts calendar date (Year, Month, Day) to Julian date
%
% Use As:   juldate(y,mo,d)
%
% Input:    y  = integer year as in 1979
%           mo = integer month 1..12
%           d  = integer day of month 1..31
% Output:   days from julian date 0: sometime in 4712 BC
%
% Example:  juldate(1979,6,14) -> 2444038.500
%
% Note:     Notice that the julian date starts at NOON, not midnight.
%           This function returns the date starting at midnight, hence
%           the fractional date in this example.
%
% See Also: CALDATE, DEG2DMS, DMS2DEG, JULDAY, JULSEC, NOW
%           JULDATE_.MEX

% Copyright (c) 1996 by Moss Landing Marine Laboratories
% Adapted from JULIAN_DATE.FOR and PLOT.HPL
% 22 Jan 96; W. Broenkow
% 25 Mar 96; W. Broenkow vectorised
%  7 Jun 96; WWB changed help
% 27 Oct 96; WWB allow column or row vector inputs

if nargin == 2 & size(YEAR) ~= size(MONTH)
  disp('JULDATE Error: input vectors must be same size')
  return
end
if nargin == 3 & size(YEAR) ~= size(DAY)
  disp('JULDATE Error: input vectors must be same size')
  return
end
[a,b] = size(YEAR);
if a > b
  YEAR = YEAR';
 if nargin > 1
  MONTH = MONTH';
 end
 if nargin > 2
  DAY = DAY';
 end
end

test  = MONTH.*100 + DAY <= 228;
itest = find(test == 1);
if any(itest)
  MONTH(itest)  = MONTH(itest) + 12;  % vectorize if M*100 +D <= 228
  YEAR(itest)   = YEAR(itest)  -  1;
end

P1 =  1720994.5 + fix(365.25.*YEAR) + fix(30.6.*(MONTH + 1)) + DAY;

test  = (YEAR.*10000 + MONTH.*100 + DAY) > 15821015;
itest = find(test == 1);                               % vectorized
if any(itest)
  P2(itest) = YEAR(itest)./100.0;
  P1(itest) = P1(itest) - fix(P2(itest)) + 2.0 +  fix(P2(itest)./4.0);
end
yyy = P1;
if a > b
  yyy = yyy';
end
