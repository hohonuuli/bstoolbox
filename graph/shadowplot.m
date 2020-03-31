function [ph, sh] = shadowplot(X,Y,Z, varargin)
% SHADOWPLOT - Creates a 3d plot with shadows of the line
%
% Use as: [ph, sh] = shadowplot(x,y,z)
%
% outputs: ph = plot handle to the line
%          sh = plot handles to the shadows

% Brian Schlining
% 03 May 2000

% Grab the hold state fo the current figure and axes
NextPlotF = get(gcf, 'NextPlot');
NextPlotA = get(gca, 'NextPlot');

% Toggle th hold state to 'on'
set(gcf, 'NextPlot', 'add');
set(gca, 'NextPlot', 'add');

% Plot
ph = plot3(X,Y,Z, varargin{:});
grid on
set(gca,'ZDir', 'reverse');
XLim = get(gca, 'XLim');
YLim = get(gca, 'YLim');
ZLim = get(gca, 'ZLim');
sh(1) = plot3(X,Y, ones(size(Z))*ZLim(2), varargin{:});
sh(2) = plot3(X,ones(size(Y))*YLim(2), Z, varargin{:});
sh(3) = plot3(ones(size(X))*XLim(2),Y, Z, varargin{:});

set(sh, 'Color', [0.8 0.8 0.8]);

% Return to original hold state
set(gcf, 'NextPlot', NextPlotF);
set(gca, 'NextPlot', NextPlotA);