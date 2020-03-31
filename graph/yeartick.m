function tH = yeartick(ax, h, dax)
% YEARTICK  - Add year ticks to a graph
%
% Use as: daytick(ax, h, dax)
%
% Inputs: ax = 'x', 'y', or 'z'. The default is 'x'.
%         h  = handle of the plot to daytick (gca is default); [] = gca
%         dax = number of year interval between ticks
%
% Will add ticks at 00:00:00 on each day

% Brian Schlining
% 30 Nov 2000

labels = [];

% Check inputs
if nargin < 1
   ax = 'x';
end

if nargin < 2
   h = gca;
end

if isempty(h)
   h = gca;
end

if nargin < 3
   dax = 1;
end

if nargin==1 & ~isstr(ax),
  error('The axis must be ''x'',''y'', or ''z''.');
end

% Specify the correct attributes
switch lower(ax)
case 'x'
   Tick      = 'XTick';
   TickLabel = 'XTickLabel';
   Label     = 'XLabel';
case 'y'
   Tick      = 'YTick';
   TickLabel = 'YTickLabel';
   Label     = 'YLabel';
case 'z'
   Tick      = 'ZTick';
   TickLabel = 'ZTickLabel';
   Label     = 'ZLabel';
end

% Get the tick positions
axLim = get(h, [ax 'lim']);
[year month day] = datevec(axLim);
if year(1) == year(2)
   year(2) = year(2) + 1;
end
years = year(1):year(2);
tick = datenum(years, 1, 1);
if tick(1) < axLim(1)
   tick = tick(2:end);
end
set(h, Tick, tick)
axLabel = num2str(years');
axLabel = axLabel(:,3:4);

% Remove the TickLabels
set(h, TickLabel, '');

% Estimate the location of the TickLabels based on the position
% of the axLabel
hx    = get(h, Label);    % Handle to label
pos   = get(hx,'Position'); % Position of labels
Ticks = get(h, Tick) - 365/2;     % Value of each tick

if ~iscell(axLabel)
   axLabel = cellstr(axLabel);
end

n = length(axLabel);
m = 0;

switch lower(ax)
case 'x'
   y   = pos(2);
   % Place the new labels
   for i = 1:length(Ticks)
      m = m + 1;
      if m > n
         m = 1;
      end
      tH(i) = text(Ticks(i), y, axLabel{m});
   end
case 'y'
   x   = pos(1);
   % Place the new labels
   for i = 1:length(Ticks)
      m = m + 1;
      if m > n
         m = 1;
      end
      tH(i) = text(x, Ticks(i), axLabel{m});
   end

end
set(tH,'HorizontalAlignment', 'center')
set(h, TickLabel, ' ');

