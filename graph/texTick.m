function ttH = texTick(ax, axLabel, axH)
% texTick   - Add LaTex formatted axes labels to a 2-D plot
% 
% Use as: tH = texTick(ax, axLabel)
% Inputs: ax = a string 'x' or 'y' specifying the axis 
%         axLabel = an array or cell array of strings 
% Output: tH = Handles to the new labels
%
% Example: plot(1:10);texTick('x', {'10^1','10^2','10^3','10^4',...
%            '10^5','10^6','10^7','10^8','10^9','10^{10}'})

% Brian Schlining (with help from Mathworks/Shannon Hays)
% 13 Jun 2000

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
end

if nargin < 3
   axH = gca;
end


% Remove the TickLabels
set(axH, TickLabel, '');   

% Estimate the location of the TickLabels based on the position
% of the axLabel
hx    = get(axH, Label);    % Handle to label
pos   = get(hx,'Position'); % Position of labels
Ticks = get(axH, Tick);     % Value of each tick

if ~iscell(axLabel)
   axLabel = cellstr(axLabel)
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


if nargout
   ttH = tH;
end


