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
