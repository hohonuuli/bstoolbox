function J = palette5(m)
% PALETTE5 - Custom colormap for satellite imaging
% First line is black, last is white. otherwise it's te same map as PALETTE4
%
% Use as: J = palette4(m)
% Output: colormap with length m

% Brian Schlining
% 08 Jun 2000

if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
n = max(ceil(m/5),1);

x1 = linspace(0.5, 0, n);
x2 = linspace(0, 0.5, n);
x3 = ones(1, ceil(n/2))*0.5;
x4 = linspace(0.5, 1, floor(n/2));
x5 = ones(1,n);
x6 = linspace(1, 0.5, n);
r  = [x1 x2 x3 x4 x5 x6]';

x1 = linspace(0, 1, n*2);
x2 = ones(1, n);
x3 = linspace(1, 0, n*2);
g  = [x1 x2 x3]';

x1 = linspace(0.5, 1, n);
x2 = ones(1,n);
x3 = linspace(1, 0.5, ceil(n/2));
x4 = [ones(1,floor(n/2)) * 0.5];
x5 = linspace(0.5, 0, n);
x6 = zeros(1,n);
b  = [x1 x2 x3 x4 x5 x6]';



J = [r g b];

while size(J,1) > m
   J(1,:) = [];
   if size(J,1) > m, J(size(J,1),:) = []; end
end

[r c] = size(J);
J(1,:) = [0 0 0];
J(r,:) = [1 1 1];






