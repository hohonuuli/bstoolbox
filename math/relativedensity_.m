function g = relativedensity_(f, f0, r)
% RELATIVEDENSITY_ - Calculate relative density between 2 distributions
%
% Usage:
%   g = relativedensity_(f, f0, r)
%
% Inputs:
%   f = Samples from the outcome space
%   f0 = Samples from a comparison outcome space
%   r = the proportion (e.g. probality) values where 0 <= r(n) <= 1
%
% Outputs:
%   g = The relative density
%
% Example:
%   women = [0:40 10:30 15:25 18:22 25 27 27 28 29 29 30 30 31 32 33 34 40 45 50];
%   men = [0:50 10: 50 10:50 20:40 20:40 20:40 25:35 25:35 35 35 35 20:70 60 63 70 71 80];
%   r = [0:0.05:1];
%   g = relativedensity_(women, men, r);
%   binEdges = [0:5:100];
%   figure
%   subplot(4, 1, 1)
%   hw = histc(women, binEdges);
%   bar(binEdges, hw)
%   xlabel('hourly wage [dollars] of comparison, women')
%   subplot(4, 1, 2)
%   hm = histc(men, binEdges);
%   bar(binEdges, hm)
%   xlabel('hourly wage [dollars] of reference, men')
%   subplot(4, 1, 3)
%   plot(r, g)
%   xlabel('proportion of men, r')
%   ylabel('Relative density, g(r)')
%   subplot(4, 1, 4)
%   q = quantile(men, r);
%   r0 = percentile(women, q);
%   plot(q, r);hold on;plot(q, r0, 'r')


q = quantile(f, r)     % value of f at r
r0 = percentile(f0, q) % value of r in f0 at q

g = r(:) ./ r0(:);


