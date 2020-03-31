function [str,status] = strpad_(Ostr,pad);

% STRPAD_   - Pads String with Blanks
%
% Use STRPAD_ to create a string of known length or to 
% return a string that will be inserted into a string 
% array with a defined length.  For example, CapS is 
% 32 characters long.  STRPAD_ will either add blanks 
% to increase the length of the string or truncate the
% string. 
%
% Use as:   [str,status] = strpad_(Ostr,pad)
%
% Input:    Ostr   = string to be padded, the string can
%                    be an array
%           pad    = total number of characters in string
%
% Output:   str    = padded string
%           status = Status of strpad_
%                  status = 1, Correct input
%                  status = 0, Incorrect input
%           
% Example:  s = strpad_('ABC',8) -> 'ABC     ' 
%      Or:  s = strpad_(['ABCD';'EFGH'],10) --> ['ABCD      ';'EFGH      ']

% 11 Mar 96; S. Flora - added ability to pad string arrays and work
%                       on empty strings
% 21 Mar 96, S. Flora - added status and checking isstr(Ostr)
% 06 Jun 96; S. Flora - Fmt, Npts, Scl, and Vaux not found
% 06 Jun 96; D. Peters - Fmt, Npts, Scl, and Vaux not in help
% 07 Jun 96; S. Flora - added printing help of nargin == 0
% 25 Jun 96; M. Hearne - Vaux not found

status = 1;

if nargin == 0
  help strpad_
  return
end

if nargin ~= 2
  disp('  STRPAD_ Error (2 Inputs required)')
  status = 0;
  str = '';
  return
end

if ~isstr(Ostr)
  disp('  STRPAD_  Error (Input must be a string)')
  status = 0;
  str = '';
  return
end

if isempty(Ostr); Ostr = ' ';end
[M N] = size(Ostr);
% Used in MLEDIT
for h = 1:M
    str = '';
    str = deblank(Ostr(h,:));       % up to the last interesting character
    l = length(str);                % the length of the goodstuff

    if l > pad,
      str = str(1,1:pad);           %Don't let the string be greater
      l = length(str);              %than the pad
    end;

   s(h,1:pad)  = [str(1:l) blanks(pad-l)];   % pad the string and return
   str = s;
end
