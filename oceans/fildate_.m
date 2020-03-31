function fdate = fildate_(juldy,year) 
% FILDATE_ - Calculate packed file date from julian day of year. 
% 
% Use As:    fdate  = fildate_(juldy,y) 
% 
% Input:     juldy  = julian day of year 1..366 
%            y      = year as a 2 or 4-digit year 96 or 1996 
%                     30..99 is used as 1930..  
%                     00..29 is used as 2000.. 
%                     1985 any 4-digit year         
% Output:    fdate  = YYMMDD packed year, month, day 
% 
% Example:   fdate  = fildate_(123,87) -> 870503 
% 
% See Also:  JULDATE_, JULDAY_, JULSEC_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 11 Jun 96; W. Broenkow 
 
if year < 30 
  year = 2000 + year; 
end 
if year < 100 
  year = 1900 + year; 
end 
jan01 = juldate_(year,1,0); 
jdate = jan01 + juldy; 
ymd   = caldate_(jdate); 
ymdS  = sprintf('%07.4f',ymd); 
fdate = str2num([ymdS(6:7) ymdS(4:5) ymdS(1:2)]); 
 
