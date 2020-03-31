function [Year,Month,Day,Hour,Minute,Second,DOY,HR] = timeupk_(T1,option) 
 
% timeupk_ - Unpack time from the YYMMDD.HHMMSS or DD.MMYY packed form into Y,M,D,H,M,S 
% 
% Use As:  [Year,Month,Day,Hour,Minute,Second,DOY,HR] = timeupk_(T1,option) 
%  
% For Option = 0: 
% Inputs:   T1     = time as YYMMDD.HHMMSS 
% Output:   Year   = 4-digit year 
%           Month  = month (1-12) 
%           Day    = day of month (1-31) 
%           Hour   = hour of day (0-23) 
%           Minute = minute (0-59)  
%           Second = second (0-59) 
%           DOY    = julian day of year (1-365) 
%           HR     = decimal hour of day (1-24) 
%           for option = 1: 
%           Year   = 4-digit year 
%           Month  = month (1-12) 
%           Day    = day of month (1-31) 
% For Option = 1: 
% Input:    T1     = time as DD.MMYY 
% Output:   Year   = 4-digit year 
%           Month  = month (1-12) 
%           Day    = day of month (1-31) 
%
% Example: [Year,Month,Day,Hour,Minute,Second,DOY,HR]   = timeupk_(891017.170400,0) ->
%           89   10    17  17   04     00     290 17.07
%          [Year,Month,Day,Hour,Minute,Second,DOY,HR] = timeupk_(17.1089,1) ->
%           1989 10    17  NaN  NaN    NaN    290 NaN  
% 
% See Also: CALDATE_, DEG2DMS_, DMS2DEG_, JULDAY_, TIMEPK_ 
% NOTE: This function is not vectorized. Use it in a loop. 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 06 Jun 96; W.Broenkow 
% 09 Sep 96; S. Flora - changed to use a string to unpack the time 
%                       this eliminates the rounding errors. So that 
%                       941114.220000 does not return Hour = 21, Min = 99 
%                       sec = 99.99997206032276 
% 21 Dec 96; W. Broenkow added unpacking of DD.MMYY 
 
if nargin < 2 
 option = 0; 
end 
 
% The trouble with the string method is that it is not vectorized 
 
if option == 0  
  if isnan(T1) 
    Year  = NaN; 
    Month = NaN; 
    Day   = NaN; 
    Hour  = NaN; 
    Minute = NaN; 
    Second = NaN; 
    DOY    = NaN; 
    Hour   = NaN; 
    return 
  end 
  str    = sprintf('%013.6f',T1); 
  Year   = str2num(str(1:2)); 
  Month  = str2num(str(3:4)); 
  Day    = str2num(str(5:6)); 
  Hour   = str2num(str(8:9)); 
  Minute = str2num(str(10:11)); 
  Second = str2num(str(12:13)); 
 
  DOY = julday_(Year,Month,Day,0); 
  HR  = Hour + Minute/60 + Second/3600; 
else 
  if isnan(T1) 
    Year  = NaN; 
    Month = NaN; 
    Day   = NaN; 
    Hour  = NaN; 
    Minute = NaN; 
    Second = NaN; 
    DOY    = NaN; 
    Hour   = NaN; 
    return 
  end 
  str    = sprintf('%07.4f',T1); 
  Year   = str2num(str(6:7)); 
  Month  = str2num(str(4:5)); 
  Day    = str2num(str(1:2)); 
  Hour   = NaN; 
  Minute = NaN; 
  Second = NaN; 
  if Year < 30 
    Year = 2000 + Year; 
  else 
    Year = 1900 + Year; 
  end 
  DOY = julday_(Year,Month,Day,0); 
  HR  = NaN; 
end 
   
