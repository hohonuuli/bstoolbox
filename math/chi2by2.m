function chi = chi2by2(s1, s2, aph)
% CHi2BY2 - The chi2 test for consistency in a 2x2 table
%
% Usage:
%   chi = chi2by2(s1, s2)
%   chi = chi2by2(s1, s2, aph)
%
% Inputs:
%   s1 = sample set 1
%   s2 = sample set 2
%   aph = alpha, default = 0.1
%
% Outputs:
%   chi = The test statistic

% Brian Schlining
% 20120-08-16

if length(s1) ~= 2 || length(s2) ~= 2
    error(['bstoolbox:' mfilename], 'Inputs must have a length of 2')
end

if min(s1 <= 3) || min(s2 <= 3) 
    error(['bstoolbox:' mfilename], 'All cell frequencies must by greater than 3')
end

n = sum(s1) + sum(s2);
if n < 20
    error(['bstoolbox:' mfilename], 'The sum of all cell frequencies must by greater than 20')
end

a = s1(1);
b = s1(2);
c = s2(1);
d = s2(2);

top = (n - 1) * (a * d - b * c) ^ 2;
bottom = (a + b) * (a + c) * (b + d) * (c + d);
chi = top / bottom;

