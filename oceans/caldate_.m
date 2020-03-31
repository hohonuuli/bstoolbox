function [p2,p6,p8,p9,h,mn,s,yy] = caldate_(p1,option) 
 
% CALDATE_ - Convert Julian date to calendar date in DD.MMYY or Y,M,D formats 
% 
% Use As:   [date y mo d h mn s] = caldate_(julian_date,option) 
% 
% Input:    julian_date =    1) julian day of the year (1-366) when option parameter is present
%                         or 2) fractional days from beginning of Julian calendar
%           option      =  0 for non-leap year
%                       =  1 for leap-year
%                       =  4-digit year calculate if leap year
% Output:
%   1)  for julian day of year option
%           date        = packed date in DD.MM
%           y           = 4-digit year (when used as input)         
%           month       = 1 - 12 
%           day         = day of month (1-31) 
%   2)  for julian date option    
%           date        = packed calendar date in DD.MMYY format 
%           y           = 4-digit year 
%           mo          = month (1-12)
%           d           = day of month (1-31)
%           h           = hour 
%           mn          = minute 
%           s           = second
% 
% Example:
%       (1) [date,y,mo,d] = caldate_(166,0)    -> 15.06,    nan, 6, 15   
%           [date,y,mo,d] = caldate_(166,1)    -> 14.06,    nan, 6, 14
%           [date,y,mo,d] = caldate_(166,1972) -> 14.0672, 1972, 6, 14 
%       (2) [date,y,mo,d,h,mn,s] = caldate_(2444038.54321) -> 14.0679, 1979, 6, 14, 1, 2, 13 
%           [date,y,mo,d,h,mn,s] = caldate_(2440000.5)     -> 24.0568, 1968, 5, 24, 0, 0, 0 
% 
% Note:     The julian date starts at noon_, hence the fraction 0.5  
%           in the last example. 
% 
% See Also: DEG2DMS_, DMS2DEG_, HELPDATE, JULDATE_, JULDAY_, JULSEC_, NOW 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 15 May 1995; W. Broenkow 
%  9 Jun 96; WWB changed help  
% 20 Jun 96; WWB added h,m,s            
% 21 Jun 96; WWB debugged changed round to floor line 
% Copied from PLOT function "CAL Date"  
% 09 Sep 96; S. Flora - changed m to mn so minutes is output 
% 27 Oct 96; W. Broenkow allow use of row or column vectors 
% 03 Feb 97; S. Flora - changed i4 = find(p8 < 2) to i4 = find(p8 < 3); 
%                       otherwise dates in Feb are off by one year. 
% 27 Sep 97; W. Broenkow added the julian day of year input
 
if nargin > 1
  if option == 0 
    Feb = 28;
    p6  = nan;
  elseif option == 1  
    Feb = 29;
    p6  = nan;
  else 
    if rem(option,4) == 0    % Then these are leap years
      p6  = option;          % pass year in as option
      Feb = 29;
    else
      p6 = option;      
      Feb = 28;                   
    end
  end

  daymon = [0 31 Feb 31 30 31 30 31 31 30 31 30 31];
  days   = cumsum(daymon);
  p8     = max(find(p1 > days));    % month
  p9     = p1 - days(1, p8);        % day of month
  p2     = p9 + p8/100;             % DD.MM 
  if p8 > 12
    disp('CALDATE_ Error Invalid Julian Day')
  end 
  h = nan; mn=nan; s=nan; yy = nan;
  return
else
  [a,b] = size(p1); 
  if(a > 1) 
    p1 = p1'; 
  end   
  p3 = rem(p1 + 0.5,1);                 % julian days 
  p4 = floor(p1 + 0.5); 
  i1 = find(p4 >= 2299161); 
  if any(i1) 
    p5(i1) = floor((p4(i1) - 1867216.25)./36524.25); 
    p4(i1) = p4(i1) + p5(i1) + ones(size(i1)) - floor(p5(i1)/4);
 
   end; 
   p5 = p4 - 1720995; 
 
   yy = (p5 - 122.1)./365.25; 
 
   p6 = floor((p5 - 122.1)./365.25);     % year 
   p7 = floor(365.25.*p6); 
   p8 = floor((p5-p7)./30.6001);         % month 
   p9 = p5 - p7 - floor(30.6.*p8); 
   p10 = floor(p9 + p3);                 % day of month; 21Jun96 round -> floor  
   i2 = find(p8 >= 14);                  % must make both tests before changing p8 
   i3 = find(p8 < 14); 
   if any(i2) 
     p8(i2) = p8(i2) - 1 - 12; 
   end 
   if any(i3) 
     p8(i3) = p8(i3) - 1; 
   end 
   i4 = find(p8 < 3);                    % if Month is less than 3 add one year 
   if any(i4) 
     p6(i4) = p6(i4) + 1; 
   end; 
 
   p2 = (p6 - 1900)./10000 + p8./100 + round(p10); % pack into DD.MMYY 
 
   h  = 24*p3; 
   m  = (h - floor(h))*60; 
   s  = (m - floor(m))*60; 
   h  = floor(h);            % hour 
   mn = floor(m);            % minute 
   s  = floor(s);            % second 
  if(a > 1)            % columns input so make output columns too
 
    p1 = p1'; 
    p2 = p2'; 
    p6 = p6'; 
    p8 = p8'; 
    p9 = p9'; 
     h = h'; 
     m = m'; 
     s = s'; 
    mn = mn'; 
  end   
end
 
