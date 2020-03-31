function x = dround_(y,d,updn)
% DROUND_ - Rounds decimal value to the significant digit
% Use As:   y = dround_(x,d)
% Input:    x = input value
%           d = significant digit for rounding
%        updn =  0 use ROUND
%             =  1 use CEIL
%             = -1 use FLOOR
% BUGGY !!!           
% Output:  y = rounded value
%
% Example:     dround_(76543,3)   ->   76500
%              dround_(76543,3,1) ->   76600
%              dround_(76543,2,-1)->   76000
%              dround_(0.2468,3)  -> 0.24700
%
% See Also:    PROUND_, CEIL, FLOOR, ROUND

% 8 Nov 1997; W. Broenkow

d = floor(d);           % no funny business with fractional values
L = ceil(log10(y));
x = y./10.^(L);
x = pround_(x,-d,updn);
x = x.*10.^(L);
