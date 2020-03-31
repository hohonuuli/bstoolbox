function x = pround_(y,p,updn)
% PROUND_ - Round value to the decimal exponent
% Use As:     y = pround_(x,p,updn)
% Input:      x = input value
%             p = decimal exponent for rounding
%          updn =  0 to round use ROUND  (default)    
%                 -1 to round down use FLOOR
%                 +1 to round up use CEIL
%             
% Output:  y = rounded value
%
% Example:     pround_(76543,3,-1)  ->  76000
%              pround_(76543,3, 0)  ->  77000
%              pround_(76543,3, 1)  ->  77000
%              pround_(0.2468,-2,0) -> 0.2500
%
% See Also:    DROUND_

% 8 Nov 1997; W. Broenkow

if nargin < 3
  updn = 0;
end
if nargin < 2
  disp('PROUND_ Error function requires 2 input arguments')
  help pround_
end

p = floor(p);              % no decimal power, please
x = y./10.^(p);
if updn == 0
  x = round(x).*10.^(p);
elseif updn > 0
  x = ceil(x).*10.^(p);
elseif updn < 0
  x = floor(x).*10.^(p);
end
