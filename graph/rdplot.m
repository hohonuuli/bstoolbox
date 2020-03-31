function rdplot(y, y0, r)
% RDPLOT - Relative density plot
%
% Usage:
%   rdplot(s, s0, r)
%
% Inputs:
%   y = Samples from the comparison outcome space
%   y0 = Samples from a reference outcome space
%   r = the proportion (e.g. probality) of y / y0 values relaive to q0(r) where 0 <= r(n) <= 1
%
% Example:
%   women = [0:40 10:30 15:25 18:22 25 27 27 28 29 29 30 30 31 32 33 34 40 45 50];
%   men = [0:50 10: 50 10:50 20:40 20:40 20:40 25:35 25:35 35 35 35 20:70 60 63 70 71 80];
%   r = [0:0.05:1];
%   rdplot(women, men, r)


% Brian Schlining
% 2012-06-06

g = relativepdf(y, y0, r);

min_ = min([min(y) min(y0)]);
max_ = max([max(y) max(y0)]);
n = max([length(y) length(y0)]) * 2;
binEdges = linspace(min_, max_, 20);

% Get PDFs
[~, d x] = kde(y, n, min_, max_);
[~, d0 x0] = kde(y0, n, min_, max_);

%[d x] = ksdensity(y, linspace(min_, max_, n));
%[d0 x0] = ksdensity(y0, linspace(min_, max_, n));

% Get Histograms
h = histc(y, binEdges);
h0 = histc(y0, binEdges);

% Plot
figure
subplot(3, 1, 1)
plotyy(binEdges, h, x, d, @bar, @line)
xlabel('comparison distribution, y')
subplot(3, 1, 2)
plotyy(binEdges, h0, x0, d0, @bar, @line)
xlabel('reference distribution, y0')
subplot(3, 1, 3)
plot(r, g)
hold on
plot([0 1], [1 1], 'k--')
xlabel('proportion of comparison, r')
ylabel('Relative density, g(r)')
set(gca, 'YGrid', 'on')