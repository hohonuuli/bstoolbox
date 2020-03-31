function daytick(ax, h, dax)
% DAYTICK   - Add day ticks to a graph
%
% Use as: daytick(ax, h, dax)
%
% Inputs: ax = 'x', 'y', or 'z'. The default is 'x'.
%         h  = handle of the plot to daytick (gca is default); [] = gca
%         dax = number of day interval between ticks
%
% Will add ticks at 00:00:00 on each day

% Brian Schlining
% 30 Nov 2000

labels = [];

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

axLim = get(h, [ax 'lim']);
lim = floor(axLim);
tick = lim(1):dax:lim(2);
if tick(1) < axLim(1)
   tick = tick(2:end);
end

[year month day hour] =  datevec(tick);
for i = 1:length(tick)
   labels{i} = [num2str(month(i)) '/' num2str(day(i))];
end
set(h, [ax 'Tick'], tick, [ax 'TickLabel'], labels)