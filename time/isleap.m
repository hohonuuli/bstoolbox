function i = isleap(Year)
% ISLEAP    - Determine if year is a leap year
%
% Use as: i = isleap(Year)
% Inputs: Year = Numerical year (ex. 1992 NOT 92)
% Output: logical 1 if it is a leap year, otherwise
%
% Example: Year = 1990:2000;
%          isleap(Year)
%          ans = 0 0 1 0 0 0 1 0 0 0 1

% B. Schlining
% 21 Oct 1997

i  = rem(Year,4);       % Leap years are evenly divisible by 4
i  = find(~i);