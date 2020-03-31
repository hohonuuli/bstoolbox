function cmap = hotcold(n);
% HOTCOLD   - Creates a red-white and blue colormap
% HOTCOLD(M) returns an M-by-3 matrix containing a "hotcold" colormap.
%    HOT, by itself, is the same length as the current colormap.
% 
%    For example, to reset the colormap of the current figure:
% 
%              colormap(hotcold)
%
%   See also HSV, GRAY, PINK, COOL, BONE, COPPER, FLAG, PALETTE4
%   COLORMAP, RGBPLOT.

% Brian Schlining
% 11 Sep 2000

if nargin < 1, n = size(get(gcf,'colormap'),1); end

if rem(n, 2)
   cmap = [fliplr(hot(n/2)); flipud(hot(n/2))];
else
   cmap = [fliplr(hot(n/2));1 1 1; flipud(hot(n/2))];
end
