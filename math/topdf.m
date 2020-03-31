function [f, x] = topdf(y, edges)
% TOPDF - convert a sample set to a probability density function
%
% Usage: 
%   [f x] = topdf(s)
%   [f x] = topdf(s, edges)
%
% Inputs:
%   s = the samples
%   edges = the values used to bin the samples for generating a histogram. 
%
% Outputs:
%   f = probabilty density
%   x = The values that f has been evaluated at

% Brian Schlining
% 2012-06-05

y = y(~isnan(y));
y = y(:);

if nargin < 2
    edges = [-Inf; sort(unique(y)); Inf];
else
    edges = edges(:);
end

h = histc(y, edges);
area = h(1:end -1) .* diff(edges);
totalArea = nansum(area(1:end-1));
f = area ./ totalArea;
x = edges(1:end - 1) + diff(edges);



