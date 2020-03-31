function [X, bad, good] = excise(X)
% EXCISE    - Remove all rows containing NaNs
%
% Use as: [x i j] = excise(x)
% Inputs: x = matrix of column oriented data
%         i = indices of rows containing NaN's
%         j = indices of rows not containing NaN's
% output: matrix with any rows containing NaN's removed

% B. Schlining
% 09 May 1998
% 14 Jan 2000; Added indices output

bad      = any(isnan(X)');
good     = find(all(~isnan(X)'));
X(bad,:) = [];
bad      = find(bad);