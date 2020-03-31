function [Year,Month,Day,Hour,Minute,Second] = timesnc_(T1) 
% timesnc_ - Return the time between T1 and T2 in specified Units 
% 
% Use As:   DT = timesnc_(T1,T2,Units) 
%  
% Inputs:   T1    = initial   time as YYMMDD.HHMMSS 
%           T2    = following time as YYMMDD.HHMMSS 
%           Units = 1 to return time interval in Seconds 
%                   2      "     "      "        Hours 
%                   3      "     "      "        Days 
%                   4      "     "      "        Years 
% Output:   DT    = time interval in selected units 
% 
% See Also: CALDATE_, DEG2DMS_, DMS2DEG_, JULDAY_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 6 June 96; W.Broenkow 
 
Y1 = round(T1);               % integer part of date  YYMMDD 
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
 
JD  = julday_(Year,Month,Day,1); 
Sec = 86400*JD + 3600*Hour + 60*Minute + Second; 

