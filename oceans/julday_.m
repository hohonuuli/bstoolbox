function [jd,dow] = julday_(y,mo,d,option) 
% JULDAY_ - Determine the julian day of the year (1..365) or julian date 
% 
% Use As:   [jday,dow] = julday_(y,mo,d,option) 
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
% Example:  julday_(79,06,14,0)    -> 165 
%           julday_(79,06,14,1)    -> 24440385 
%           julday_(1582,10,15,1)  -> 2299170.5 
%           julday_(1968,5,23.5,1) -> 2440000.0 
%           julday(1582,10,16) - julday_(1582,10,15) -> -9 !!  
%              This is because the Julian calendar 
%              started at noon_ on 15 October 1582 
%              Julian Date 0 is 4712 BC 
% 
% See Also: CALDATE_, DEG2DMS_, DMS2DEG_, HELPDATE, JULDATE_, JULSEC_, NOW_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Uses function juldate_.m 
% 15 Apr 95; W. Broenkow 
% 29 Jan 96; replaced juldate_.mex by juldate_.m 
% 25 Mar 96; WWB vectorized added day of week, debugged 
% 21 Jun 96; WWB changed help  
 
if ~exist('option'), 
option = 0; 
end; 
if (nargin < 3),  
  jd = NaN;  
  disp('ERROR:  JULDAY_ Must input 3 arguments:  day, month, year') 
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
  jd  = juldate_(yr,mo,d); 
  dow = 1+rem(floor(jd)+2,7); 
else 
  jd1  = juldate_(yr,ones(size(yr)),zeros(size(yr)));  % julian date for first of given year 
  jd2  = juldate_(yr,mo,d);                            % julian date 
  jd   = jd2 - jd1;              % number of days from Jan 0 = day of year 
  dow  = 1+ rem(floor(jd2+2),7); % day of the week 1=Sunday 
end 
