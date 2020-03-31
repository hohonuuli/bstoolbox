function TOUT = now_(option,T) 
% NOW_ - Return the system time as YYMMDD.HHmmSS or  
%          convert time and date to different formats 
% 
% Use As:   ymdhms = now_(option,T) 
% 
% Input:    option = 0 to return YYMMDD.HHmmSS 
%           option = 1 to return YY.MMDD 
%           option = 2 to return DD.MMYY 
%           option = 3 to return HH.MMSS 
%           option = 4 to return decimal hours of this day 
%           option = 5 to return seconds from juldate_ = 0 
%           option = 6 to return HH:MM:SS as a string 
%           T = user entered time as [Year,Month,Day,Hour,Minute,Second] 
%               do not use system time   
%  
% Output:   ymdhms = YYMMDD.HHmmSS  packed year,month,day.hour,minute,second                           
%      or            HH.MMSS        packed hour.minute,second 
% 
% Example:  now_                          -> 960607.14523543 
%           now_(1)                       -> 96.0607 
%           now_(3)                       -> 14.534233 
%           now_(0,[1996,06,10])          -> 960610.000000 
%           now_(0,[1996,06,10,11,22,33]) -> 960610.112233 
%           now_(4,[1996,06,10,11,22,33]) -> 11.91666666666667 
%           now_(5)                       -> 2.117009221124511e+011 seconds 
%           now_(6)                       -> '15:38:54' 
% 
% See Also: CALDATE_, JULDATE, JULDAY_, JULSEC_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% This function requires julsec_.M 
% 6 Jun 96; W. Broenkow 
% 9 Jun 96; WWB added annotation, allow use of truncated time vector 
% 21 May 97; WWB renamed to avoid conflict with Matlab 5.0 
 
if nargin == 0 
  option = 0; 
end 
if nargin < 2 
  T  = clock;       % Determine input time from computer 
end 
 
if nargin == 2 
  [m,n] = size(T); 
  if n == 1; 
    T = T'; 
    n = m; 
  end 
  t = zeros(size(1:6)); 
  t(1:n) = T(1:n); 
  T = t; 
end 
 
Year   = T(1); 
Month  = T(2); 
Day    = T(3); 
Hour   = T(4); 
Minute = T(5); 
Second = T(6); 
 
if Year < 2000 
  YY = (Year - 1900); 
else 
  YY = (Year - 2000); 
end 
 
if option == 0 | option == 5 
  TOUT = 10000*YY + 100*Month + Day + Hour/100 + Minute/10000 + Second/1000000; 
elseif option == 1 
  TOUT = YY + Month/100 + Day/10000; 
elseif option == 2 
  TOUT = Day + Month/100 + YY/10000; 
elseif option == 3 
  TOUT = Hour + Minute/100 + Second/10000; 
elseif option == 4 
  TOUT = Hour + Minute/60 + Second/60; 
else 
  TOUT = 10000*YY + 100*Month + Day + Hour/100 + Minute/10000 + Second/1000000;   
end 
if option == 5 
  TOUT = julsec_(TOUT); 
end 
if option == 6 
  hs = sprintf('%02i',Hour); 
  ms = sprintf('%02i',Minute); 
  ss = sprintf('%02i',floor(Second)); 
  TOUT = [hs ':' ms ':' ss]; 
end  
