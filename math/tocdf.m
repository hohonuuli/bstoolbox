function [c x] = tocdf(s)
% TOCDF - Create a cumulative distribution function from a sample set
%
% Usage:
%   [c x] = tocdf(s)
%
% Inputs:
%   s = A sample set
%
% Outputs:
%   c = cumulative probability at x
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


binEdges = [-Inf; s(:); Inf];
binCounts = histc(s, binEdges);
sumCounts = cumsum(binCounts) ./ sum(binCounts);
c = sumCounts(1:end - 1);

[x is ix] = unique(s);
c = c(is);


