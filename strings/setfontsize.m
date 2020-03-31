function setfontsize(FontSize)
% SETFONTSIZE - Set the fontsize on all text components of a plot
%
% Use as: setfontsize(fontSize)
%
% Inputs: fontSize = integer specifying the font size (default = 7)

% Brian Schlining
% 16 Sep 1999

if ~nargin
   FontSize = 7;
end

h = findobj(gcf,'type','text');
if ~isempty(h)
   set(h,'FontSize',FontSize);
end
ah = get(gcf,'Children');
for i = 1:length(ah)
   set(ah(i),'FontSize',FontSize);
   h = findobj(ah(i),'type','text');
   if ~isempty(h)
      set(h,'FontSize',FontSize);
   end
   h = get(ah(i),'XLabel');
   if ~isempty(h)
      set(h,'FontSize',FontSize);
   end
   h = get(ah(i),'YLabel');
   if ~isempty(h)
      set(h,'FontSize',FontSize);
   end
   h = get(ah(i),'ZLabel');
   if ~isempty(h)
      set(h,'FontSize',FontSize);
   end
   h = get(ah(i),'Title');
   if ~isempty(h)
      set(h,'FontSize',FontSize);
   end
end
