function p = percentile(s, v)
% PERCENTILE - Calculate the percentile position of a value within a set
%
% Usage:
%   p = percentile(s, v)
%
% Inputs:
%   s = The set (v should be a member of the set)
%   v = value whos percentile we want to Calculate
%
% Outputs:
%   p = percentile position of v in s (p will be between 0 and 1)
%

% Brian Schlining
% 2012-06-04


[y x] = tocdf(s);
p = interp1(x, y, v);
%p = interpstineman(x, y, v);
