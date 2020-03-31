function y = datefmt_(P1,P2,P3,option) 
 
% datefmt_   Returns a string containing the date in dow-dd-mmm-yy format. 
% 
% Use As: y = datefmt_(YY,MM,DD,option)  
%  Or As: y = datefmt_(YY.MMDD,option) 
% 
% Inputs: YY.MMDD or YY, MM, and DD the Year 
%              Month and Day in either format 
%         Option = Which format to return 
%            0   Tue 03-Nov-96 (default) 
%            1   Tuesday 03-Nov-96  
%            2   Tuesday 03-November-96 
%            3   03-Nov-96 
%            4   03-November-96 
%            5   Tue 
%            6   Tuesday  
% Example:   datefmt_(1997,9,5,0) -> Fri 05-Sep-1997
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 22 Dec 96; S. Flora - created for nhtml_ 
% 23 Dec 96; S. Flora - added options 
% 22 Jun 98; S. Flora - Rewritten and Works in Matlab 5.2
 
status = 1; 
 
if nargin == 0 
  help date_fmt 
  return 
end 
 
if nargin == 1 
  dstr = sprintf('%09.4f',P1); 
  YY = str2num(dstr(1:4)); 
  MM = str2num(dstr(6:7)); 
  DD = str2num(dstr(8:9)); 
  option = 0; 
elseif nargin == 2 
  dstr = sprintf('%09.4f',P1); 
  YY = str2num(dstr(1:4)); 
  MM = str2num(dstr(6:7)); 
  DD = str2num(dstr(8:9)); 
  option = P2; 
elseif nargin == 3 
  YY = P1; 
  MM = P2; 
  DD = P3; 
  option = 0; 
elseif nargin == 4 
  YY = P1; 
  MM = P2; 
  DD = P3; 
end 
 
[s, MM] = chckint_('  DATE_FMT','MM',MM,1,12,2); 
if s == 1 & status == 0; 
  status = 0; 
elseif s == 0 
  status = 0; 
end 
 
[s, DD] = chckint_('  DATE_FMT','DD',DD,1,31,2); 
if s == 1 & status == 0; 
  status = 0; 
elseif s == 0 
  status = 0; 
end 
 
[s, option] = chckint_('  DATE_FMT','option',option,0,6,1); 
if s == 1 & status == 0; 
  status = 0; 
elseif s == 0 
  status = 0; 
end 
 
if status == 0; 
  return 
end 
 
[jday,dow] = julday_(YY,MM,DD,0); 
 
% Don't return a day of week 
if option == 3 | option == 4 
  dow = 8; 
end 
 
if option == 0 | option == 1 | option == 3 
  months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun'; 
            'Jul';'Aug';'Sep';'Oct';'Nov';'Dec']; 
elseif option == 2 | option == 4  
  months = ['January  '; 
            'Febuary  '; 
            'March    '; 
            'April    '; 
            'May      '; 
            'June     '; 
            'July     '; 
            'August   '; 
            'September'; 
            'October  '; 
            'November '; 
            'December ']; 
end 
 
if option == 0 | option == 3 | option == 4 | option == 5  
  weeks = ['Sun';'Mon';'Tue';'Wed';'Thu';'Fri';'Sat';'   ']; 
elseif option == 1 | option == 2 | option == 6 
  weeks = ['Sunday   '; 
           'Monday   '; 
           'Tuesday  '; 
           'Wednesday'; 
           'Thursday '; 
           'Friday   '; 
           'Saturday '; 
           '         ']; 
end 
 
DDstr = sprintf('%02i',DD); 
 
if option < 5 
  y = [deblank(weeks(dow,:)), ' ', DDstr ,'-',deblank(months(MM,:)),'-',int2str(YY)]; 
elseif option > 4 
  y = deblank(weeks(dow,:)); 
end 
 
ind = find(abs(y) ~= 32);       % Find First non-blank character 
y = y(ind(1):length(y));        % Remove leading blanks 
