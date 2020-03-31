function m = specmean(V,w)
% SPECMEAN  - Calculate a spectral mean
%
% Use as: m = specmean(V,n);
% Inputs: V = vector of spectral data
%         w = weighting vector; This gives he weights used for each
%             point when calculating the mean. It must be odd in length
%             with the center point specifiying the point at which the average 
%             is calculated
%
%             if w is a scalar; it will use an unweigthed mean using w points to
%             either side of a given point. To get a 29 point moving average, w 
%             should 14.
%
% Output: m = weighted mean
%
% example: m = specmean([2 2 1 2 3 2 0 -1 -1 0 1 -2], 4)   % is the same as:
%          m = specmean([2 2 1 2 3 2 0 -1 -1 0 1 -2], [1 1 1 1 1 1 1 1 1])
%
%          ans = 
%                 NaN NaN NaN NaN 1.1111 0.8889 0.7778 0.4444 NaN NaN NaN NaN
%
%
%          m = specmean([2 2 1 2 3 2 0 -1 -1 0 1 -2], [1 2 3 4 5 4 3 2 1])
%
%          ans =
%                 NaN NaN NaN NaN 1.4800 1.0800 0.6400 0.2000 NaN NaN NaN NaN

% Brian Schlining
% 11 Nov 1997
% 14 Apr 2000 - Fixed an imput checking error

%=========================================
% Make sure w is a colum vector or scalar
%=========================================
[r c] = size(w);
l     = length(w);
if r > 1 | c > 1
   error('Input w must be a scalar.');
end
n = w;
w = ones(2*n+1,1);   % Create blank w

%================================================
% Check length and make sure it's odd or scalar.
% If it's scalar create a blank weigthing vector
%================================================
l = length(V);

%=============================
% Make sure V is a row vector
%=============================
Flag = 'row';
[r c] = size(V);
if r > 1 & c > 1
   error('Input V must be a vector, not a matrix');
elseif c == 1
   V = V';              % Transpose V to be a row vector
   Flag = 'column';     % Turn on transpose flag to return same orientation as given
end

%==========================================
% Create a matrix of all data to be summed
% This is the heart of the program
%==========================================
for i = -n:n           % Create the column matrix of data to be averaged
   if i < 0
      M(i+n+1,:) = [V(-i+1:l) ones(1,-i)*NaN];
   elseif i == 0
      M(i+n+1,:) = V;
   elseif i > 0
      M(i+n+1,:) = [ones(1,i)*NaN V(1:l-i)];
   end
end

m = nanmedian(M);

if strcmp('column',Flag)        % Transpose to orginal orientation if nescessary
   m = m';
end