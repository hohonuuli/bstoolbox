function g = relativepdf(y, y0, r)
% relativepdf - Calculate relative probability density between 2 distributions
%
% Usage:
%   g = relativepdf(y, y0, r)
%
% Inputs:
%   y = Samples from the comparison outcome space
%   y0 = Samples from a reference outcome space
%   r = the proportion (e.g. probality) of y / y0 values relaive to q0(r) where 0 <= r(n) <= 1
%
% Outputs:
%   g = The relative density
%
% Example:
%   women = [0:40 10:30 15:25 18:22 25 27 27 28 29 29 30 30 31 32 33 34 40 45 50];
%   men = [0:50 10: 50 10:50 20:40 20:40 20:40 25:35 25:35 35 35 35 20:70 60 63 70 71 80];
%   r = [0:0.05:1];
%   g = relativepdf(women, men, r);
%   binEdges = [0:5:100];
%   figure
%   subplot(3, 1, 1)
%   hw = histc(women, binEdges);
%   bar(binEdges, hw)
%   xlabel('hourly wage [dollars] of reference, women')
%   subplot(3, 1, 2)
%   hm = histc(men, binEdges);
%   bar(binEdges, hm)
%   xlabel('hourly wage [dollars] of comparison, men')
%   subplot(3, 1, 3)
%   plot(r, g)
%   xlabel('proportion of women, r')
%   ylabel('Relative density, g(r)')
%   set(gca, 'YGrid', 'on')

min_ = min([min(y) min(y0)]);
max_ = max([max(y) max(y0)]);
n = max([length(y) length(y0)]) * 2;

% Get PDFs
[~, d x] = kde(y, n, min_, max_);
[~, d0 x0] = kde(y0, n, min_, max_);

%[d x] = ksdensity(y, linspace(min_, max_, n));
%[d0 x0] = ksdensity(y0, linspace(min_, max_, n));

% makes sure arrays have same dimensions
x = x(:);
d = d(:);
x0 = x0(:);
d0 = d0(:);

q0 = quantile(y0, r);      % value of y0 at r
f0 = interp1q(x0(:), d0(:), q0(:)); % value of f0 at q0(r) i.e. probability density
f = interp1q(x(:), d(:), q0(:)); % value of f at q0(r)

g = f ./ f0;
