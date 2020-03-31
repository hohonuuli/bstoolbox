function J = jetplus(m)
%JETPLUS    Variant of JET.
%   JETPLUS(M), a variant of JET(M)
%
%   See also HSV, HOT, PINK, FLAG, COLORMAP, RGBPLOT.

%   Brian Schlining
%   $Id: jetplus.m,v 1.1 2005/04/13 20:38:33 brian Exp $

if nargin < 1, m = size(get(gcf,'colormap'),1); end
n = max(round(m/5),1)-1;
k = n + 5;
x = (1:n)'/n;
y = (n/2:n)'/n;
e = ones(length(x),1);
%r = [linspace(0.9, 0, n)'; 0*y; 0*e; x; e; flipud(y)]; %.75
r = [linspace(0.9, 0, k)'; 0*y; 0*e; x; e; linspace(1, .3, length(y))'];
g = [zeros(k,1); 0*y; x; e; flipud(x); 0*y];
b = [linspace(0.75, 0.50, k)'; y; e; flipud(x); 0*e; 0*y]; %.64
J = [r g b];
while size(J,1) > m
   J(1,:) = [];
   if size(J,1) > m, J(size(J,1),:) = []; end
end
