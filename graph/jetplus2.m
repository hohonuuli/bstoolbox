function J = jetplus2(m)
%JETPLUS2    Variant of HSV.
%   JET(M), a variant of HSV(M), is the colormap used with the
%   NCSA fluid jet image.
%   JET, by itself, is the same length as the current colormap.
%   Use COLORMAP(JET).
%
%   See also HSV, HOT, PINK, FLAG, COLORMAP, RGBPLOT.

%   C. B. Moler, 5-10-91, 8-19-92.
%   Copyright 1984-2000 The MathWorks, Inc. 
%   $Revision: 1.1 $  $Date: 2005/04/13 20:38:33 $

if nargin < 1, m = size(get(gcf,'colormap'),1); end
n = max(round(m/6),1)-1;
k = n + 6;
x = (1:n)'/n;
y = (n/2:n)'/n;
e = ones(length(x),1);
%r = [linspace(0.9, 0, n)'; 0*y; 0*e; x; e; flipud(y)]; %.75
r = [linspace(0.9, 0, k)'; 0*y; 0*e; x; e; linspace(1, .30, length(y))';linspace(0.3, .75, k)';];
g = [zeros(k,1); 0*y; x; e; flipud(x); 0*y;linspace(0, 0.2, k)'];
b = flipud(r);
%b = [linspace(0.75, 0.30, k)'; y; e; flipud(x); 0*e; 0*y ]; %.64
b = [linspace(1, 0.30, k)'; y; e; flipud(x); 0*e; 0*y;zeros(k,1); ];
J = [r g b];
while size(J,1) > m
   J(1,:) = [];
   if size(J,1) > m, J(size(J,1),:) = []; end
end
