function setfontname(FontName)
% SETFONTNAME - Set the font on all text components of a plot
%
% Use as: setfontname(FontName)
%
% Inputs: fontName = String specifying the font

% Brian Schlining
% 16 Sep 1999

if ~nargin
   FontName = 7;
end

h = findobj(gcf,'type','text');
if ~isempty(h)
   set(h,'FontName',FontName);
end
ah = get(gcf,'Children');
for i = 1:length(ah)
   set(ah(i),'FontName',FontName);
   h = findobj(ah(i),'type','text');
   if ~isempty(h)
      set(h,'FontName',FontName);
   end
   h = get(ah(i),'XLabel');
   if ~isempty(h)
      set(h,'FontName',FontName);
   end
   h = get(ah(i),'YLabel');
   if ~isempty(h)
      set(h,'FontName',FontName);
   end
   h = get(ah(i),'ZLabel');
   if ~isempty(h)
      set(h,'FontName',FontName);
   end
   h = get(ah(i),'Title');
   if ~isempty(h)
      set(h,'FontName',FontName);
   end
end
