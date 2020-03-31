function JS = julsec_(T1,option) 
% JULSEC_ - Return the Julian date in seconds from packed calendar date 
% 
% Use As:   JS = julsec_(DATETIME,option) 
%  
% Inputs:   DATETIME = date and time as packed value YYMMDD.hhmmss 
%                      YY is year 00 to 30 implies 2000 to 2030
%                                 31 to 99 implies 1931 to 1999
%                      MM is month (1-12) 
%                      DD is day of month (1-31) 
%                      hh is hour   (00 to 23) 
%                      mm is minute (00 to 59) 
%                      ss is second (00 to 59.9999) 
%           option   = choose output units 
%                      0 = seconds; 1 = days 
%                      An error message is displayed for erroneous  
%                      dates and times 
% Output:   JS       = Julian Date in seconds or days 
% 
% Example:  julsec_(960616.123456)   -> 2.117016884960010e+011  seconds   
%           ie. 16 June 1996 12:34:56 
%           julsec_(960616.123456,1) -> 2.450250500000000e+006  days   
% 
% NOTE:     To avoid truncation errors, 1 millisecond is added to T1 
% 
% See Also: CALDATE_, DEG2DMS_, DMS2DEG_, HLPDATE_, JULDATE_, JULDAY_, NOW_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
%  6 Jun 96; W.Broenkow 
%  9 Jun 96; W.Broenkow added small time to avoid errors; added day option 
% 21 Jun 96; wwb debugged seconds and day option  
 
status  = 1; 
dstatus = 1;
if nargin < 2 
  option = 0; 
end 
 
T1 = T1 + .000000001;         % add millisecond to avoid truncation error 
Y1 = floor(T1);               % integer part of date  YYMMDD 
H1 = T1 - Y1;                 % fractional part      .HHMMSS 
YY    = floor(Y1/10000); 
Month = floor(100*(Y1/10000 - YY)); 
Day   = Y1 - (YY*100 + Month)*100; 
if YY < 30;  
  Year = 2000 + YY; 
else 
  Year = 1900 + YY; 
end 
Hour    = floor(100*H1); 
Minute  = floor(10000*H1 - 100*Hour);  
Second  = 100*(10000*H1 - 100*Hour - Minute); 
 
if Hour > 23 | Hour < 0 
  disp('JULSECND Error: Impossible Hour') 
  status = 0 
end 
if Minute > 59 | Minute < 0 
  disp('JULSECND Error: Impossible Minute') 
  status = 0; 
end 
if Second > 59.9999 | Second < 0 
  disp('JULSECND Error: Impossible Second') 
  status = 0; 
end 
if Month > 12 | Month < 1 
  disp('JULSECND Error: Impossible Month ... Valid = 1 to 12') 
  status = 0; 
end 
if Year < 1931 & Year > 2030 
  disp('JULSECND Error: Impossible Year ... Valid = 00 to 99') 
  status = 0; 
end 
DM = [31,28,31,30,31,30,31,31,30,31,30,31]; 
if Month > 0 & Month < 13 
 if Day > DM(1,Month) | Day < 1 
   dstatus = 0; 
   status  = 0; 
 end     
end 
if dstatus == 0 & Month == 2 & rem(Year,4) == 0    %  29 Feb leap year 
  status  = 1; 
  dstatus = 1; 
end 
if dstatus == 0 
  status = 0; 
  disp('JULSECND Error: Impossible Day ... Valid = 01 to 31') 
end 
if status == 0 
  fprintf('Year %4i Month %2i Day %2i Hour %2i Minute %2i Second %2i \n',Year,Month,Day,Hour,Minute,Second) 
  return 
end 
 
JD = julday_(Year,Month,Day,1) + Hour/24 + Minute/1440 + Second/86400; 
JS = 86400*JD; 
if option ~= 0 
  JS = JD;                             % return julian date in days 
end 
 
