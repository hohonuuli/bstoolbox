function [i, d] = near(x,p,n);
% NEAR      - Finds the indices of x that are closest to the point p.
%
% Use as: [i,d] = near(x, p, n);
%
% Inputs: x = vector or values
%         p = point to find closest value to
%         n = number of closest points to get (in order of increasing distance)
%             Distance is the abs(x - p). [Optional argument, default = 1]
%
% Output: i = indices (n in length) of returned values from x
%         d = distances between x(i) and p

% Brian Schlining
% 07 Jun 1999

if nargin == 2
   n = 1;
end

[r c] = size(x);

if r > 1 & c > 1
   error('  NEAR: Input x must be a vector, not a matrix');
end   


[d, i] = sort(abs(x - p));
d      = d(1:n);           % Distance
i      = i(1:n);           % Index

