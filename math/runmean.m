function m = runmean(V,n)
% RUNMEAN   - Calculate a running mean
%
% Use as: m = runmean(V,n);
% Inputs: V = vector of data to calculate running mean from
%         n = number of points to use in calculating mean. 
%             The first n-1 points will be set to NaN.
% Output: m = running mean
%
% example: m = runmean([2 2 1 2 3 2 0 -1 -1 0 1 -2], 4)
%          ans = 
%                 NaN NaN NaN 1.75 2.25 2 1.75 1 0 -.5 -.25 -.5

% Brian Schlining
% 11 Nov 1997

Flag = 'row';

[r c] = size(V);
if r > 1 & c > 1
   error('Input V must be a vector, not a matrix');
elseif c == 1
   V = V';              % Transpose V to be a row vector
   Flag = 'column';
end

l = length(V);
if l < n
   error(['Vector V must have at least ' num2str(n) ' points'])
end

for i = 1:n-1           % Create the column matrix of data to be averaged
   V(i+1,:) = [ones(1,i)*NaN V(1,1:l-i)];
end

m = mean(V);
if strcmp('column',Flag)
   m = m';
end
