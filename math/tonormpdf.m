function [p x] = tonormpdf(s)
% TONORMPDF - Create a normal probability distribution function from a sample set
%
% Usage:
%   [p x] = tonormpdf(s)
%
% Inputs:
%   s = A sample set
%
% Outputs:
%   p = probability at x
%   x = sorted set of all unique values in s

% Brian Schlining
% 2012-06-04


% Ensure each sample is a vector
[rs cs] = size(s);
if rs ~= 1 & cs ~= 1
    error(['BSTOOLBOX:' mfilename, 'Set, s, must be a vector']);
end

% Remove missing observations indicated by NaN's
s = sort(s(~isnan(s)));
m = median(s);
ss = std(s);
[x is ix] = unique(s);
p = dnorm(x, m, ss);

