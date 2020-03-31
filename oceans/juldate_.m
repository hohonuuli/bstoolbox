function JD = juldate2(YEAR,MONTH,DAY) 
% JULDATE_ - Converts calendar date (Year, Month, Day) to Julian date 
% 
% Use As:   juldate2(y,mo,d) 
% 
% Input:    y  = integer year as in 1979 
%           mo = integer month 1..12 
%           d  = integer day of month 1..31 
% Output:   days from julian date 0: sometime in 4712 BC  
%       
% Example:  juldate_(1979,6,14) -> 2444038.500 
% 
% Note:     Notice that the julian date starts at noon_, not midnight. 
%           This function returns the date starting at midnight, hence 
%           the fractional date in this example.  
% 
% See Also: CALDATE_, DEG2DMS_, DMS2DEG_, JULDAY_, JULSEC_, NOW_ 
%           JULDATE_.MEX

% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Adapted from NUMERICAL RECIPIES but vectorized                    
% 14 Nov 97; WWB start from scratch
% 14 Mar 2000; B. Schlining, Output arguments are now same shape as inputs

if nargin == 2 & size(YEAR) ~= size(MONTH) 
   disp('JULDATE Error: input vectors must be same size') 
   return 
end 
if nargin == 3 & size(YEAR) ~= size(DAY) 
   disp('JULDATE Error: input vectors must be same size') 
   return 
end 
[a,b] = size(YEAR); 
flag = 0;
if a > b 
   YEAR = YEAR'; 
   flag = 1;
   if nargin > 1 
      MONTH = MONTH'; 
   end 
   if nargin > 2 
      DAY = DAY'; 
   end 
end 

IGREG = 588829; % date when gregorian calendar was adopted

ix = find(YEAR < 0);
YEAR(ix) = YEAR(ix) + 1;

JY = YEAR  - 1;
JM = MONTH + 13;

ix = find(MONTH > 2);
JY(ix) = YEAR(ix);
JM(ix) = (MONTH(ix) + 1);

JD = floor(365.25*JY) + floor(30.6001*JM) + DAY + 1720995 - 0.5;  % Numerical Recipies does not use the 0.5

JJ = (DAY + 31*(MONTH + 12*YEAR));

ix = find(JJ >= IGREG);
JA(ix) = floor(0.01*JY(ix));
JD(ix) = JD(ix) + 2 - JA(ix) + floor(0.25*JA(ix));

if flag
   JD = JD';
end
