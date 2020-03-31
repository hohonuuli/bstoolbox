function  DateTime = timepk_(Year,Month,Day,Hour,Minute,Second) 
% timepk_ - Pack Y,M,D,H,M,S in the YYMMDD.HHMMSS format 
% 
% Use As:  DateTime = timepk_(Year,Month,Day,Hour,Minute,Second)
%  
% Inputs:   Year     = 2 or 4-digit year 
%           Month    = month (1-12) 
%           Day      = day of month (1-31) 
%           Hour     = hour of day (0-23) 
%           Minute   = minute (0-59)  
%           Second   = second (0-59) 
% Output:   DateTime = time as YYMMDD.HHMMSS 
% 
% Example: DateTime = timepk_(1996,9,16,22,0,0) 
% Example: fprintf('%12.6f \n', timepk_(1996,9,16,22,30,15))   
%          -> 960916.223015 
% See Also: CALDATE_, DEG2DMS_, DMS2DEG_, JULDAY_, TIMEUPK_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 23 Sep 96; S. Flora - converted from timeunpk 
 
if nargin == 0 
  help timepk 
  return 
end 
 
if nargin < 3 
  disp('  TIMEPK_ Error (3 Inputs Required!)') 
  return 
end 
 
if nargin < 4 
  Hour   = 0; 
  Minute = 0; 
  Second = 0; 
end 
if nargin < 5 
  Minute = 0; 
  Second = 0; 
end 
if nargin < 6 
  Second = 0; 
end 
 
Ystr    = sprintf('%04.0f',Year); 
Mstr    = sprintf('%02.0f',Month); 
Dstr    = sprintf('%02.0f',Day); 
Hstr    = sprintf('%02.0f',Hour); 
mstr    = sprintf('%02.0f',Minute); 
Sstr    = sprintf('%02.0f',Second); 
 
if length(Ystr) > 2 
  Ystr = Ystr(length(Ystr)-1:length(Ystr)); 
end 
 
DateTime = str2num([Ystr Mstr Dstr '.' Hstr mstr Sstr]); 
