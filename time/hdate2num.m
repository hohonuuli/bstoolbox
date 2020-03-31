function N = hdate2num(D)
% HDATE2NUM - Hierarchial date to serial date number
%
% Use as: N = hdate2num(D)
%
% Inputs: D = Hierarchial date (number or string)
%             An example of a hierarchial date is 19980812 for 12 Aug 1998
%
% Output: N = date number corresponding to the hierarchial date
% 
% See also: DATENUM,DATEVEC,DATESTR, DATE2JUL DY2DATE

% Brian Schlining
% 18 Aug 1999

if isstr(D)
   D = str2num(D);
end

[r c] = size(D);
if r > 1 & c > 1
   error('  HDATENUM: Input must be a vector, not a matrix');
end


Year  = floor(D/10000);
Month = floor((D - (Year*10000))/100);
Day   = floor(D - (Year*10000) - (Month*100));

N = datenum(Year, Month, Day);
